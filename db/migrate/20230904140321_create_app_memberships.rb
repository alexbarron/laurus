class CreateAppMemberships < ActiveRecord::Migration[7.0]
  def change
    create_table :app_memberships do |t|
      t.boolean :admin, default: false
      t.references :developer_app, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
