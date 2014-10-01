class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :topic, counter_cache: true
  has_many :notifications, as: 'subject', dependent: :delete_all
  has_many :likeships, as: :likeable, foreign_key: "likeable_id", dependent: :destroy
  has_many :likers, through: :likeships, source: :user
  validates :body, presence: true
  after_create :send_notification_to_at_users
  after_destroy :delete_all_notifications

  def delete_all_notifications
    notifications.delete_all
  end

  def send_notification_to_at_user(at_user)
    unless at_user == self.user 
      Notification.create(user: at_user,
                          subject: self,
                          name: 'mention')
    end
  end

  def send_notification_to_blogger(at_user)
    blogger = self.topic.user
    unless blogger == at_user || blogger == self.user
      Notification.create(user: blogger,
                          subject: self,
                          name: 'comment')   
    end
  end

  private
  def send_notification_to_at_users
    at_users = []
    self.body.gsub /@(\w+)/ do |username|
      name = username.gsub('@', '')
      user = User.find_by_name(name)
      at_users << user if user.present?
    end

    at_users.each do |at_user| 
      self.send_notification_to_at_user(at_user)
      send_notification_to_blogger(at_user)
    end

    if at_users.empty?
      send_notification_to_blogger('')
    end
  end

end