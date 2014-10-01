class NotificationsController < ApplicationController

  def index
    @notifications = current_user.notifications.includes(:subject).order(id: :desc).paginate(page: params[:page], per_page: 20)
    current_user.notifications.unread.update_all(read: true, updated_at: Time.now.utc)
  end

  def destroy
    @notification = current_user.notifications.find params[:id]
    @notification.destroy
  end

  def clear
    current_user.notifications.delete_all
  end

end