class Parameter < ApplicationRecord
  has_many :parameter_references
  has_many :endpoints, through: :parameter_references
  enum :location, %i[path query header cookie]

  validates :name, presence: true
  validates :data_type, presence: true, inclusion: {in: %w[string number integer boolean array object]}
  validates :location, presence: true
end
