class Endpoint < ApplicationRecord
  serialize :responses, JsonbSerializers
  serialize :request_body, JsonbSerializers

  has_many :grants
  has_many :developer_apps, through: :grants

  has_many :parameter_references
  has_many :parameters, through: :parameter_references

  has_many :schema_references
  has_many :dependent_schemas, through: :schema_references, source: :parent

  validates :path, presence:   true,
                   length:     {maximum: 50},
                   uniqueness: {scope: :method, message: "and method pair already exists"}
  validates :method, presence: true, inclusion: {in: %w[GET POST PUT PATCH DELETE]}

  scope :ordered_by_path, -> { order(path: :asc, method: :asc) }

  alias_attribute :http_method, :method

  def self.import_openapi(spec)
    OpenAPIService::ImportService.new(spec).call
  end
end
