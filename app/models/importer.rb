# Imports feeds from spot
class Importer

  attr_accessor :xml, :xdoc, :url

  def initialize(xml: nil, url: nil)
    if xml && url
      raise 'Only init Importer with xml OR url'
    end

    @xml = xml
    @url = url

    if @xml
      @xdoc = Importer.load_xml(@xml)
    end

    if @uri
      # TODO
    end
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
      sf = SpotFeed.where(feed_id: feed_id).first_or_initialize
      sf.name = get_text(feed, 'name')
      sf.description = get_text(feed, 'description')
      sf.status = get_text(feed, 'status')
      sf.usage = get_text(feed, 'usage').to_i
      sf.days_range = get_text(feed, 'daysRange')
      sf.detailed_message_shown = get_text(feed, 'detailedMessageShown') == 'true'
      sf.save!
      return sf
    end
    nil
  end

  def load_messages
    if (sf = spot_feed_from_xdoc) &&
       (messages = @xdoc.xpath('//message'))
      res = []
      messages.each do |msg|
        spot_id = get_text(msg, 'id').to_i
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

  class << self
    def load_sample_xml
      File.open('data/sample-spot-data.xml').read
    end

    def load_xml(xml)
      Nokogiri::XML(xml)
    end
  end
end