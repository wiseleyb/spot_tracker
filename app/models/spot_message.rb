class SpotMessage < ActiveRecord::Base
  belongs_to :spot_feed

  scope :mapable, -> { where.not(message_type: 'HELP-CANCEL') }
end
