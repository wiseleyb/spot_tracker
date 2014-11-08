class SpotGroupsController < ApplicationController
  before_action :set_spot_group, only: [:show, :edit, :update, :destroy]

  def index
    @spot_groups = SpotGroup.all
    respond_with(@spot_groups)
  end

  def show
    respond_with(@spot_group)
  end

  def new
    @spot_group = SpotGroup.new
    respond_with(@spot_group)
  end

  def edit
  end

  def create
    @spot_group = SpotGroup.new(spot_group_params)
    @spot_group.save
    respond_with(@spot_group)
  end

  def update
    @spot_group.update(spot_group_params)
    respond_with(@spot_group)
  end

  def destroy
    @spot_group.destroy
    respond_with(@spot_group)
  end

  private
    def set_spot_group
      @spot_group = SpotGroup.find(params[:id])
    end

    def spot_group_params
      params.require(:spot_group).permit(:name)
    end
end
