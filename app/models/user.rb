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
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[linkedin]

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.linkedin_data"] && session["devise.linkedin_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
        
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.picture_url = auth.info.picture_url
      user.password = Devise.friendly_token[0, 20]
    end
  end
  
  private

    def associate_app_invitations
      AppInvitation.where(invitee_email: self.email).update_all(invitee_id: self.id)
    end
end
