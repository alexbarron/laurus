class AppInvitation < ApplicationRecord
    belongs_to :invitee, class_name: 'User', optional: true
    belongs_to :inviter, class_name: 'User'
    belongs_to :developer_app

    before_create :set_status_pending

    private

        def set_status_pending
            self.status = "pending"
        end
end
