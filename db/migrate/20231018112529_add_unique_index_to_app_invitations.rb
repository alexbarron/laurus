class AddUniqueIndexToAppInvitations < ActiveRecord::Migration[7.0]
  def change
    add_index :app_invitations, %i[developer_app_id invitee_email], unique: true
  end
end
