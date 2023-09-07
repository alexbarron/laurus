class Grant < ApplicationRecord
  belongs_to :endpoint
  belongs_to :developer_app
end
