class Schema < ApplicationRecord
  serialize :properties, JsonbSerializers

  has_many :parent_references, class_name: "SchemaReference", foreign_key: "referenced_id"
  has_many :parent_schemas, through: :parent_references, source: :dependent
  has_many :endpoints, through: :parent_references

  has_many :dependent_references, class_name: "SchemaReference", foreign_key: "schema_id"
  has_many :dependent_schemas, through: :dependent_references, source: :parent

  validates :name, presence: true
  validates :data_type, presence: true, inclusion: {in: %w[string number integer boolean array object]}
  validates :properties, presence: true
end
