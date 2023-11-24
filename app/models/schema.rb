class Schema < ApplicationRecord
  serialize :properties, JsonbSerializers

  has_many :parent_references, class_name: "SchemaReference", foreign_key: "referenced_id"
  has_many :parent_schemas, through: :parent_references, source: :child_schema

  has_many :child_references, class_name: "SchemaReference", foreign_key: "schema_id"
  has_many :child_schemas, through: :child_references, source: :parent_schema

  validates :name, presence: true
  validates :data_type, presence: true, inclusion: {in: %w[string number integer boolean array object]}
  validates :properties, presence: true
end
