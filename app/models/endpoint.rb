class Endpoint < ApplicationRecord
  has_many :grants
  has_many :developer_apps, through: :grants
  has_and_belongs_to_many :parameters

  validates :path, presence:   true,
                   length:     {maximum: 50},
                   uniqueness: {scope: :method, message: "and method pair already exists"}
  validates :method, presence: true, inclusion: {in: %w[GET POST PUT PATCH DELETE]}

  scope :ordered_by_path, -> { order(path: :asc, method: :asc) }

  alias_attribute :http_method, :method

  def self.import_openapi(spec)
    OpenAPIImporter.new(spec).import
  end
end
