class AddUniqueIndexToEndpoints < ActiveRecord::Migration[7.0]
  def change
    add_index :endpoints, [:path, :method], unique: true
  end
end
