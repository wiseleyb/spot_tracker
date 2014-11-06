class SpotMessagesController < ApplicationController
  before_action :set_spot_message, only: [:show, :edit, :update, :destroy]

  def index
    @spot_messages = SpotMessage.all
    respond_with(@spot_messages)
  end

  def show
    respond_with(@spot_message)
  end

  def new
    @spot_message = SpotMessage.new
    respond_with(@spot_message)
  end

  def edit
  end

  def create
    @spot_message = SpotMessage.new(spot_message_params)
    flash[:notice] = 'SpotMessage was successfully created.' if @spot_message.save
    respond_with(@spot_message)
  end

  def update
    flash[:notice] = 'SpotMessage was successfully updated.' if @spot_message.update(spot_message_params)
    respond_with(@spot_message)
  end

  def destroy
    @spot_message.destroy
    respond_with(@spot_message)
  end

  private
    def set_spot_message
      @spot_message = SpotMessage.find(params[:id])
    end

    def spot_message_params
      params.require(:spot_message).permit(:spot_feed_id, :spot_id, :messenger_id, :messenger_name, :unix_time, :message_type, :latitude, :longitude, :model_id, :show_custom_msg, :date_time, :hidden, :message_content)
    end
end
