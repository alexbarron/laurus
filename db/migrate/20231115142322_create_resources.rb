class CreateResources < ActiveRecord::Migration[7.0]
  def change
    create_table :resources do |t|
      t.string :name
      t.jsonb :schema, null: false, default: "{}"

      t.timestamps
    end
    add_index :resources, :schema, using: :gin
  end
end
