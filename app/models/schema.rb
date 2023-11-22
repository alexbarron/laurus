class Schema < ApplicationRecord
  serialize :properties, JsonbSerializers

  validates :name, presence: true
  validates :data_type, presence: true, inclusion: {in: %w[string number integer boolean array object]}
  validates :properties, presence: true
end
