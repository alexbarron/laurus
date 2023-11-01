class AddInviteeEmailIndexToAppInvitations < ActiveRecord::Migration[7.0]
  def change
    add_index :app_invitations, :invitee_email
  end
end
