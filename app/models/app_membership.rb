class AppMembership < ApplicationRecord
  belongs_to :developer_app
  belongs_to :user
  has_paper_trail skip: [:id, :created_at, :updated_at, :developer_app_id]

  validates :user_id, uniqueness: { scope: :developer_app_id }
end
