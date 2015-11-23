class Post < ActiveRecord::Base

  enum status: [ :draft, :pending, :approved ]

  has_many :categories_posts
  has_many :categories, through: :categories_posts
  has_many :comments, dependent: :destroy
  has_many :tags_posts
  has_many :tags, through: :tags_posts
  has_many :subscriptions_posts
  has_many :subscribers, through: :subscriptions_posts, source: :user
  belongs_to :user

  validates :title, :body, :user_id, presence: true

  scope :approved, -> { where(status: 2) }
  scope :draft, -> { where(status: 0) }
  scope :pending, -> { where(status: 1) }

end
