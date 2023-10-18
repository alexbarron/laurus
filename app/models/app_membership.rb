class AppMembership < ApplicationRecord
  belongs_to :developer_app
  belongs_to :user

  validates :user_id, uniqueness: { scope: :developer_app_id }
end
