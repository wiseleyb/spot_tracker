class SpotFeed < ActiveRecord::Base
  has_many :spot_messages, dependent: :destroy

  def markers_json
    Gmaps4rails.build_markers spot_messages.mapable do |msg, marker|
      marker.lat msg.latitude.to_f
      marker.lng msg.longitude.to_f
      #marker.infowindow render_to_string(:partial => "/users/my_template", :locals => { :object => user}).gsub(/\n/, '').gsub(/"/, '\"')
#      marker.picture({
#        url: 'https://addons.cdn.mozilla.net/img/uploads/addon_icons/13/13028-64.png',
#        width: 16,
#        height: 16
#      })
      marker.title   "i'm the title"
      marker.json({ :id => msg.id })
    end.to_json.html_safe
  end

  def path_json
    spot_messages.mapable.map do |m|
      {
        lat: m.latitude,
        lng: m.longitude
      }
    end.to_json.html_safe
  end

  def test_large_json
    res = []
    1000.times do
      res << {lat: range(24, 49), lng: range(-124, -66)}
    end
    res.to_json.html_safe
  end

  def range (min, max)
    rand * (max-min) + min
  end
end
