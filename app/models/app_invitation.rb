class AppInvitation < ApplicationRecord
  belongs_to :invitee, class_name: "User", optional: true
  belongs_to :inviter, class_name: "User"
  belongs_to :developer_app

  before_create :set_status_pending
  before_create :set_invitee_id

  validates :invitee_email,
            presence:   true,
            length:     {maximum: 50, minimum: 3},
            format:     {with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i},
            uniqueness: {scope: :developer_app_id, message: "has already been invited to this developer app"}

  def accept
    app_membership = developer_app.app_memberships.new(
      admin:,
      user_id: invitee.id
    )
    return unless app_membership.save

    self.status = "accepted"
    save
  end

  def decline
    self.status = "declined"
    save
  end

  def closed
    %w[accepted declined].include?(status)
  end

  private

  def set_status_pending
    self.status = "pending"
  end

  def set_invitee_id
    self.invitee_id = User.find_by(email: invitee_email)&.id
  end
end
