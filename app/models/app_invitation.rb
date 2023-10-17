class AppInvitation < ApplicationRecord
    belongs_to :invitee, class_name: 'User'
    belongs_to :inviter, class_name: 'User'
    belongs_to :developer_app
end
