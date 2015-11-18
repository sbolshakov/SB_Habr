class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :confirmable, :validatable, :trackable

  has_one :profile
  has_many :posts
  has_many :comments

  def owner_of?(object)
    # Сравниваем поле user_id объекта с полем id пользователя чтобы избежать загрузки
    # пользователя для объекта из базы
    id == object.user_id || admin?
  end

end
