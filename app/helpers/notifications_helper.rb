module NotificationsHelper
  def unread_notifications_count
    if user_signed_in?
      current_user.notifications.unread.count
    end
  end
end