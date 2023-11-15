class Resource < ApplicationRecord
  serialize :schema, JsonbSerializers
  has_many :endpoints

  SCHEMA_SCHEMA = Rails.root.join("app", "models", "schemas", "resource_schema.json")
  validates :schema, presence: true, json: {message: ->(err) { err }, schema: SCHEMA_SCHEMA}
end
