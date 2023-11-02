class AddDeletedAtToAppMemberships < ActiveRecord::Migration[7.0]
  def change
    add_column :app_memberships, :deleted_at, :datetime
    add_index :app_memberships, :deleted_at
  end
end
