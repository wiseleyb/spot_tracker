# For use with http://www.geomidpoint.com/random/
class DataGenerator
  class << self

    # Take a csv of gps points from http://www.geomidpoint.com/random/
    # and add them to the system
    def create(csv)
      SpotGroup.transaction do
        sf = create_feed
        CSV.parse(csv).each_with_index do |latlng, idx|
          create_message(feed: sf, lat: latlng[1], lng: latlng[3], index: idx)
        end
      end
    end

    def destroy_random_data!
      SpotFeed.where("feed_id like 'random-%'").destroy_all
    end

    def min_max_from_messages(feed:)
      messages = feed.messages
      h = { start: {}, end: {} }
      h[:start][:lat] = messages.map(&:lat).min
      h[:end][:lat] = messages.map(&:lat).max
      h[:start][:lng] = messages.map(&:lng).min
      h[:end][:lng] = messages.map(&:lng).max
      h
    end

    def create_path(min_max_hash:,
                    feeds: nil,
                    paths: 1,
                    rnd: 3,
                    steps: 10,
                    steps_rnd: 3)
      feeds = paths.times.map { create_feed } unless feeds
      feeds = [feeds].flatten
      start_message_index ||= 1
      h = min_max_hash
      minlat = h[:start][:lat]
      maxlat = h[:end][:lat]
      minlng = h[:start][:lng]
      maxlng = h[:end][:lng]
      step_count = steps + rand(-steps_rnd..steps_rnd)
      lat_step = diff(maxlat, minlat) / step_count
      lng_step = diff(maxlng, minlng) / step_count
      lat_step = (maxlat - minlat) / step_count
      lng_step = (maxlng - minlng) / step_count
      puts "min/max", minlat, maxlat, minlng, maxlng
      puts "steps", step_count, lat_step, lng_step
      SpotGroup.transaction do
        paths.times do |path_step|
puts "PATH: #{path_step}"
          feed = feeds[path_step]
          create_message(feed: feed,
                         lat: minlat,
                         lng: minlng,
                         index: @@msg_counter += 1)
          coords = []
          step_count.times do |i|
            coord = [
              minlat + (i * lat_step) + (lat_step * rand(0.1..rnd)),
              minlng + (i * lng_step) + (lng_step * rand(0.1..rnd))
            ]
            msg_idx = (path_step * i) + i
puts "MSG_IDX #{@@msg_counter}"
            create_message(feed: feed,
                           lat: coord[0],
                           lng: coord[1],
                           index: @@msg_counter += 1)
          end
        end
      end
    end

    def create_feed
      sg = SpotGroup.first
      sf = SpotFeed.new(
        spot_group_id: sg.id,
        feed_id: "random-#{Time.now.to_f}",
        name: "Random #{Time.now.to_i}",
      )
      sf.display_name = sf.name
      sf.description = sf.name
      sf.sync = false
      sf.display = true
      sf.save!
      sf
    end

    def create_message(feed:, lat:, lng:, index:)
      SpotMessage.create!(
        spot_feed_id: feed.id,
        date_time: DateTime.now + (5 * index).minutes,
        latitude: lat.to_f,
        longitude: lng.to_f,
        message_type: 'UNLIMITED-TRACK'
      )
    end

    def load_r2ak(racers: 5)
      @@msg_counter = 0
      points = r2ak_points

      feeds = racers.times.map { create_feed }
      feeds.each_with_index do |feed, idx|
        feed.display_name = r2ak_teams[idx]
        feed.save
      end

      feeds.each do |feed|
        points[1..-1].each_with_index do |p, idx|
          puts "FROM TO", points[idx], p
          h = {
            start: { lat: points[idx].first, lng: points[idx].last },
            end: { lat: p.first, lng: p.last }
          }
          create_path(min_max_hash: h, feeds: feed)
        end
      end
    end

    def r2ak_teams
      ['Turn Point Design',
       'Barefoot Wooden Boats',
       'Real Thing',
       'Wind Waker',
       'Team Angus',
       'Canadian Currach Crew',
       'Team Scot',
       'Kohara',
       'Defiant',
       'Discovery',
       'Sea Runner']
    end
    def r2ak_points
      CSV.parse(%(48.112524, -122.752904
        48.240673, -123.097085
        48.425092, -123.388222
        48.408230, -123.402299
        48.392958, -123.277329
        48.447756, -123.262910
        48.504429, -123.290204
        48.595279, -123.325223
        48.757709, -123.343419
        49.154085, -123.568982
        49.358445, -123.941144
        49.651841, -124.604443
        49.979701, -125.045270
        50.259710, -125.388592
        50.488743, -126.246899
        50.724061, -126.939038
        51.041171, -127.735547
        51.421255, -127.812451
        51.759121, -127.933301
        52.062405, -127.914075
        52.626179, -128.482617
        53.287993, -129.147290
        53.910601, -130.223950
        54.248973, -130.366772
        54.711724, -130.656537
        54.952461, -131.035793
        55.207163, -131.357143
        55.330001, -131.666134)).map { |latlng| latlng.map(&:to_f) }
    end

    def diff(x, y)
      x > y ? x - y : y - x
    end
  end
end
