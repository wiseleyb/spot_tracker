class SpotGroup < ActiveRecord::Base
  has_many :spot_feeds, dependent: :destroy
end
