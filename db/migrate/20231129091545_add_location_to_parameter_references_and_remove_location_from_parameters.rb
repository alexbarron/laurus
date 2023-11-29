class AddLocationToParameterReferencesAndRemoveLocationFromParameters < ActiveRecord::Migration[7.0]
  def change
    add_column :parameter_references, :location, :integer
    remove_column :parameters, :location
  end
end
