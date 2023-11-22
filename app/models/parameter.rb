class Parameter < ApplicationRecord
  has_many :parameter_references
  has_many :endpoints, through: :parameter_references
  enum :location, %i[path query header cookie]

  def description(endpoint)
    parameter_references.where(endpoint_id: endpoint.id).first.description
  end
end
