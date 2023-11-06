class AddUniqueIndexToAppMemberships < ActiveRecord::Migration[7.0]
  def change
    add_index :app_memberships, %i[developer_app_id user_id], unique: true
  end
end
