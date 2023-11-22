class AddDescriptionToEndpointsParameters < ActiveRecord::Migration[7.0]
  def change
    add_column :endpoints_parameters, :description, :string
    remove_column :parameters, :description
  end
end
