class CreateGrants < ActiveRecord::Migration[7.0]
  def change
    create_table :grants do |t|
      t.references :endpoint, null: false, foreign_key: true
      t.references :developer_app, null: false, foreign_key: true

      t.timestamps
    end

    add_index :grants, [:endpoint_id, :developer_app_id], unique: true
  end
end
