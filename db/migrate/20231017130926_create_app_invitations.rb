class CreateAppInvitations < ActiveRecord::Migration[7.0]
  def change
    create_table :app_invitations do |t|
      t.integer :inviter_id
      t.integer :invitee_id
      t.string :invitee_email
      t.integer :developer_app_id
      t.boolean :admin
      t.string :status

      t.timestamps
    end
  end
end
