class Endpoint < ApplicationRecord
  has_many :grants
  has_many :developer_apps, through: :grants
  belongs_to :resource, optional: true

  validates :path, presence:   true,
                   length:     {maximum: 50},
                   uniqueness: {scope: :method, message: "and method pair already exists"}
  validates :method, presence: true, inclusion: {in: %w[GET POST PUT PATCH DELETE]}

  scope :ordered_by_path, -> { order(path: :asc, method: :asc) }

  alias_attribute :http_method, :method

  def self.import_openapi_spec(spec)
    parsed_spec = OpenAPIParser.parse(YAML.load_file(spec))
    endpoints = []
    parsed_spec.paths.raw_schema.each do |key, value|
      value.each_key do |method|
        endpoints << {
          path:        key,
          method:      method.upcase,
          description: value[method]["summary"]
        }
      end
    end
    Endpoint.create(endpoints)
  end
end
