class User < ApplicationRecord
  has_many :app_memberships, foreign_key: :user_id
  has_many :developer_apps, through: :app_memberships
  has_many :change_events
  has_many :sent_invitations, class_name: "AppInvitation", foreign_key: "inviter_id"
  has_many :received_invitations, class_name: "AppInvitation", foreign_key: "invitee_id"

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, 
    presence: true,
    length: { maximum: 255, minimum: 3 },
    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
    uniqueness: true

  after_create :associate_app_invitations
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  private

    def associate_app_invitations
      AppInvitation.where(invitee_email: self.email).update_all(invitee_id: self.id)
    end
end
