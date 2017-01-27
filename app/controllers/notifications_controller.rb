class NotificationsController < ApplicationController
  before_action :require_user
  before_action :related_to_current_user, only: [:destroy]


  # return user's notifications
  # @return [Array]
  def index
    @notifications = Rails.cache.fetch('api/notifications?user=' + current_user.cache_key) do
      current_user.notifications
    end
    render json: { notifications: @notifications }
  end

  # destroy notification
  # @return
  def destroy
    if @notification.destroy
      render :json => 'Ok'
    else
      error_message(@notification.errors.full_messages, 422)
    end
  end

  # return unread notifications for current_user
  # @return [Object]
  def count
    count = current_user.notifications.where(notifications: {readed: false}).count
    render :json => {count: count}
  end

  private

  # check if notification belongs to current_user
  def related_to_current_user
    unless (@notification = Notification.find_by_id(params[:id]))
      return error_message(['Notification not found'], 404)
    end

    unless @notification.user == current_user
      error_message(['Forbidden'], 403)
    end
  end
end
