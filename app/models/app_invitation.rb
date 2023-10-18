class AppInvitation < ApplicationRecord
    belongs_to :invitee, class_name: 'User', optional: true
    belongs_to :inviter, class_name: 'User'
    belongs_to :developer_app

    before_create :set_status_pending

    validates :invitee_email, uniqueness: { scope: :developer_app_id, message: "has already been invited to this developer app" }

    def accept
        app_membership = self.developer_app.app_memberships.new(
            admin: self.admin,
            user_id: self.invitee.id
        )
        if app_membership.save
            self.status = "accepted"
            self.save
        end
    end

    private

        def set_status_pending
            self.status = "pending"
        end
end