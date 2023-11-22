class CreateSchemas < ActiveRecord::Migration[7.0]
  def change
    create_table :schemas do |t|
      t.string :name
      t.string :title
      t.text :description
      t.string :data_type
      t.jsonb :properties, null: false, default: "{}"
      t.timestamps
    end
    add_index :schemas, :properties, using: :gin
  end
end
