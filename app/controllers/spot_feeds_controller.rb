class SpotFeedsController < ApplicationController
  before_action :set_spot_feed, only: [:show, :edit, :update, :destroy]

  def index
    @spot_feeds = SpotFeed.all
    respond_with(@spot_feeds)
  end

  def show
    respond_with(@spot_feed)
  end

  def new
    @spot_feed = SpotFeed.new
    respond_with(@spot_feed)
  end

  def edit
  end

  def create
    @spot_feed = SpotFeed.new(spot_feed_params)
    @spot_feed.save
    respond_with(@spot_feed)
  end

  def update
    @spot_feed.update(spot_feed_params)
    respond_with(@spot_feed)
  end

  def destroy
    @spot_feed.destroy
    respond_with(@spot_feed)
  end

  private
    def set_spot_feed
      @spot_feed = SpotFeed.find(params[:id])
    end

    def spot_feed_params
      params.require(:spot_feed).permit(:feed_id, :name, :description, :status, :usage, :days_range, :detailed_message_show)
    end
end
