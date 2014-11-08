require 'open-uri'

# Imports feeds from spot
class Importer

  attr_accessor :spot_feed, :xml, :xdoc, :url, :spot_message_ids

  def initialize(spot_feed: nil, xml: nil, url: nil)
    # TODO: clean this hackity hack crap up

    @spot_feed = spot_feed
    @xml = xml
    @url = url
    @spot_message_ids = []

    if @spot_feed
      @xdoc = Importer.load_url(@spot_feed.feed_url)

      # We collect these as an optimization so we reduce db
      # hits when we get messages that have already been created
      @spot_message_ids = SpotMessage.
        where(spot_feed_id: @spot_feed.id).
        select(:spot_id).
        pluck(:spot_id)
    end

    if @xml
      @xdoc = Importer.load_xml(@xml)
    end

    if @url
      @xdoc = Importer.load_url(@url)
    end

    if self.error?
      if @spot_feed
        @spot_feed.update_attributes(sync_status: self.error_message)
      end
      raise "Import failed: #{self.error_message}"
    end
  end

  class << self
    def import_feeds
      SpotFeed.syncable.each do |sf|
        Importer.new(spot_feed: sf).import rescue 'Import failed'
        sf.update_attributes(sync_status: 'SUCCESS')
        sleep 5 # required by spot api
      end
    end

    def load_sample_xml
      File.open('data/sample-spot-data.xml').read
    end

    def load_xml(xml)
      Nokogiri::XML(xml)
    end

    def load_url(url)
      Nokogiri::XML(open(url))
    end
  end

  def import
    self.load_spot_feed
    self.load_messages
  end

  def messages
    @xdoc.xpath('//message')
  end

  def load
    feed = load_spot_feed
    load_messages
    feed
  end

  def load_spot_feed
    feed = @xdoc.xpath('//feed').first
    if feed
      feed_id = get_text(feed, 'id')
      sf = SpotFeed.where(spot_group_id: SpotGroup.first.id,
                          feed_id: feed_id).first_or_initialize
      sf.name = get_text(feed, 'name')
      sf.description = get_text(feed, 'description')
      sf.status = get_text(feed, 'status')
      sf.usage = get_text(feed, 'usage').to_i
      sf.days_range = get_text(feed, 'daysRange')
      sf.detailed_message_shown = get_text(feed, 'detailedMessageShown') == 'true'
      #sf.updated_at = Time.now
      sf.save!
      return sf
    end
    nil
  end

  def messages
    @messages ||= @xdoc.xpath('//message')
  end

  def load_messages
    if (sf = spot_feed_from_xdoc) && !messages.empty?
      res = []
      messages.each do |msg|
        spot_id = get_text(msg, 'id').to_i
        next if @spot_message_ids.include?(spot_id)
        sm = SpotMessage.where(spot_id: spot_id).first_or_initialize
        sm.spot_feed_id = sf.id
        sm.messenger_id = get_text(msg, 'messengerId')
        sm.messenger_name = get_text(msg, 'messengerName')
        sm.unix_time = get_text(msg, 'unixTime').to_i
        sm.message_type = get_text(msg, 'messageType')
        sm.latitude = get_text(msg, 'latitude').to_f
        sm.longitude = get_text(msg, 'longitude').to_f
        sm.model_id = get_text(msg, 'modelId')
        sm.show_custom_msg = get_text(msg, 'showCustomMsg')
        sm.date_time = DateTime.parse(get_text(msg, 'dateTime'))
        sm.battery_state = get_text(msg, 'batteryState')
        sm.hidden = get_text(msg, 'hidden').to_i
        sm.message_content = get_text(msg, 'messageContent')
        sm.save!
        res << sm
      end
      return res
    end
    []
  end

  def spot_feed_from_xdoc
    feed = @xdoc.xpath('//feed').first
    if feed
      feed_id = get_text(feed, 'id')
      return SpotFeed.find_by_feed_id(feed_id)
    end
  end

  def get_text(doc, field)
    doc.xpath(field).first.try(:text)
  end

  def error?
    !@xdoc.xpath('//error').empty?
  end

  def error_message
    # TODO: We should have a import log
    error = @xdoc.xpath('//error')
    [get_text(error, 'code'),
     get_text(error, 'text'),
     get_text(error, 'description')].join(' ')
  end
end
