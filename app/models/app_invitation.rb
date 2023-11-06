class AppInvitation < ApplicationRecord
  belongs_to :invitee, class_name: 'User', optional: true
  belongs_to :inviter, class_name: 'User'
  belongs_to :developer_app

  before_create :set_status_pending

  validates :invitee_email,
            presence: true,
            length: { maximum: 50, minimum: 3 },
            format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
            uniqueness: { scope: :developer_app_id, message: 'has already been invited to this developer app' }

  def accept
    app_membership = developer_app.app_memberships.new(
      admin:,
      user_id: invitee.id
    )
    return unless app_membership.save

    self.status = 'accepted'
    save
  end

  def decline
    self.status = 'declined'
    save
  end

  def closed
    %w[accepted declined].include?(status)
  end

  private

  def set_status_pending
    self.status = 'pending'
  end
end
