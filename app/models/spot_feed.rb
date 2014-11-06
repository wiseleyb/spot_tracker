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
end
