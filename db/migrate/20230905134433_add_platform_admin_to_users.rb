class AddPlatformAdminToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :platform_admin, :boolean, default: false
  end
end
