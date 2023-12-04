class Schema < ApplicationRecord
  serialize :properties, JsonbSerializers

  has_many :parent_references, class_name: "SchemaReference", foreign_key: "referenced_id", dependent: :destroy
  has_many :parent_schemas, through: :parent_references, source: :dependent
  has_many :endpoints, through: :parent_references

  has_many :dependent_references, class_name: "SchemaReference", foreign_key: "schema_id", dependent: :destroy
  has_many :dependent_schemas, through: :dependent_references, source: :parent

  validates :name, presence: true
  validates :data_type, presence: true, inclusion: {in: %w[string number integer boolean array object]}
  validates :properties, presence: true

  def properties_with_dependents
    properties.each do |name, attributes|
      if attributes.has_key?("$ref")
        dependent_name = attributes["$ref"].split("/").last
      elsif attributes.has_key?("items") && !attributes["items"]["$ref"].nil?
        dependent_name = attributes["items"]["$ref"].split("/").last
      else
        next
      end

      properties[name] = dependent_schemas.where(name: dependent_name).first.properties
    end
  end
end
