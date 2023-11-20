class CreateEndpointsParametersJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :endpoints, :parameters
  end
end
