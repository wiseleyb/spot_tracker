class VisitorsController < ApplicationController
  def index
    @groups = SpotGroup.all
  end
end
