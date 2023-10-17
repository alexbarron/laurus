class User < ApplicationRecord
  has_many :app_memberships, foreign_key: :user_id
  has_many :developer_apps, through: :app_memberships
  has_many :change_events
  has_many :sent_invitations, class_name: "AppInvitation", foreign_key: "inviter_id"
  has_many :received_invitations, class_name: "AppInvitation", foreign_key: "invitee_id"
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
