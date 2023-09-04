class User < ApplicationRecord
  has_many :app_memberships, foreign_key: :user_id
  has_many :developer_apps, through: :app_memberships
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
