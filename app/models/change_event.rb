class ChangeEvent < ApplicationRecord
  belongs_to :user
  belongs_to :developer_app
end
