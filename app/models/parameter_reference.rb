class ParameterReference < ApplicationRecord
  belongs_to :endpoint
  belongs_to :parameter

  enum :location, %i[path query header cookie]
end
