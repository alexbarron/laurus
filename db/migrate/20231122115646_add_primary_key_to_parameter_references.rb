class AddPrimaryKeyToParameterReferences < ActiveRecord::Migration[7.0]
  def change
    add_column :parameter_references, :id, :primary_key
  end
end
