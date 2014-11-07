class SpotMessage < ActiveRecord::Base
  belongs_to :spot_feed

  scope :mappable, -> { where.not(message_type: 'HELP-CANCEL') }
end
