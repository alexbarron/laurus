class CreateSchemaReferences < ActiveRecord::Migration[7.0]
  def change
    create_table :schema_references do |t|
      t.integer :referenced_id
      t.integer :endpoint_id
      t.integer :schema_id
      t.timestamps
    end
  end
end
