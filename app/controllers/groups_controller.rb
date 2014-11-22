class GroupsController < ApplicationController
  def show
    @group = SpotGroup.find_by_id(params[:id])
  end
end
