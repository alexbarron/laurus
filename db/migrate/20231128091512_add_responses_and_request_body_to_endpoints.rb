class AddResponsesAndRequestBodyToEndpoints < ActiveRecord::Migration[7.0]
  def change
    add_column :endpoints, :responses, :jsonb, default: "{}"
    add_column :endpoints, :request_body, :jsonb, default: "{}"
    add_index :endpoints, :responses, using: :gin
    add_index :endpoints, :request_body, using: :gin
  end
end
