class Post < ActiveRecord::Base

  has_many :categories_posts
  has_many :categories, through: :categories_posts
  has_many :comments
  has_many :tags_posts
  has_many :tags, through: :tags_posts
  belongs_to :user

  validates :title, :body, :user_id, presence: true



end
