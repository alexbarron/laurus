class AddArchivedAtToDeveloperApps < ActiveRecord::Migration[7.0]
  def change
    add_column :developer_apps, :archived_at, :datetime
    add_index :developer_apps, :archived_at
  end
end
