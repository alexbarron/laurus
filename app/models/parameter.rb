class Parameter < ApplicationRecord
  has_and_belongs_to_many :endpoints
  enum :location, %i[path query header cookie]
end
