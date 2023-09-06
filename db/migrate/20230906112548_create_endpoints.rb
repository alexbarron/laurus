class CreateEndpoints < ActiveRecord::Migration[7.0]
  def change
    create_table :endpoints do |t|
      t.string :path
      t.string :method
      t.text :description

      t.timestamps
    end
  end
end
