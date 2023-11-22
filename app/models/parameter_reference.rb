class ParameterReference < ApplicationRecord
  belongs_to :endpoint
  belongs_to :parameter
end
