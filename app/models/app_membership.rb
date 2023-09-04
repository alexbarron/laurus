class AppMembership < ApplicationRecord
  belongs_to :developer_app
  belongs_to :user
end
