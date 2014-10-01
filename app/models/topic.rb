class Topic < ActiveRecord::Base
  belongs_to :user
  has_many :comments, dependent: :delete_all
  has_many :likeships, as: :likeable, foreign_key: "likeable_id", dependent: :destroy
  has_many :likers, through: :likeships, source: :user
  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 200 }
  validates :content, presence: true, length: { maximum: 100000 }
  scope :suggest, -> { where(suggested: true).order("updated_at desc") }
  scope :unsuggest, -> { where(suggested: false) }
  scope :excellent, -> { where(excellent: true).limit(20) }
end
