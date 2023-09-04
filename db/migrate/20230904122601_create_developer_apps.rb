class CreateDeveloperApps < ActiveRecord::Migration[7.0]
  def change
    create_table :developer_apps do |t|
      t.string :name
      t.string :client_id

      t.timestamps
    end
  end
end
