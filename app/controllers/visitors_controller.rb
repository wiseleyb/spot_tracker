class VisitorsController < ApplicationController
  def index
    @spot_group = SpotGroup.first
  end
end
