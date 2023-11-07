class Grant < ApplicationRecord
  belongs_to :endpoint
  belongs_to :developer_app

  validates :endpoint_id, uniqueness: {scope: :developer_app_id}
end
