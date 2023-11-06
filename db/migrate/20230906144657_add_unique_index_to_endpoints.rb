class AddUniqueIndexToEndpoints < ActiveRecord::Migration[7.0]
  def change
    add_index :endpoints, %i[path method], unique: true
  end
end
