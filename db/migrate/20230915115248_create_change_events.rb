class CreateChangeEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :change_events do |t|
      t.references :user, null: false, foreign_key: true
      t.references :developer_app, null: false, foreign_key: true
      t.string :event_type
      t.string :message

      t.timestamps
    end
  end
end
