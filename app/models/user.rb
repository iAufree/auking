class User < ActiveRecord::Base
  #Include default devise modules. Others available are:
  #:token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  mount_uploader :avatar, AvatarUploader
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable
  has_many :topics, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :attachments, dependent: :delete_all
  has_many :notifications, dependent: :delete_all
  has_many :likeships, foreign_key: "user_id", dependent: :destroy
  has_many :liks, through: :likeships, source: :likeable
  accepts_nested_attributes_for :attachments

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  validates :name,  presence: true, length: { maximum: 20 }, uniqueness: true
  validates :qq, numericality: { only_integer: true }, length: { in: 5..12 }, allow_nil: true
  validates :description, length: { in: 5..150 }, allow_blank: true
  
  def gender_txt
    ["保密", "男生", "女生"][self.gender - 1]
  end

  def school_txt
    ["信工学院", "药学院", "商学院"][self.school - 1]
  end

  #Find user by name
  def to_param
    name
  end

  #Like
  def liking?(likeable)
    likeships.find_by(likeable)
  end

  def like!(type, id)
    likeships.create!(likeable_type: type, likeable_id: id)
  end  

  def unlike!(type, id)
    likeships.find_by(likeable_type: type, likeable_id: id).destroy
  end
end
