class AddResourceIdToEndpoints < ActiveRecord::Migration[7.0]
  def change
    add_column :endpoints, :resource_id, :integer
  end
end
