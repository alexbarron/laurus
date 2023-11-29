class Parameter < ApplicationRecord
  has_many :parameter_references
  has_many :endpoints, through: :parameter_references

  validates :name, presence: true
  validates :data_type, presence: true, inclusion: {in: %w[string number integer boolean array object]}
end
