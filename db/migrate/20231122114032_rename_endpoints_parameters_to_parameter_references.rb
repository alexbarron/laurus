class RenameEndpointsParametersToParameterReferences < ActiveRecord::Migration[7.0]
  def change
    rename_table :endpoints_parameters, :parameter_references
  end
end
