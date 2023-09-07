class DeveloperApp < ApplicationRecord
    has_many :app_memberships, foreign_key: :developer_app_id
    has_many :members, through: :app_memberships, source: :user
    has_many :grants
    has_many :endpoints, through: :grants

    before_create :generate_client_id

    private

        def generate_client_id
            self.client_id = SecureRandom.base64(16)
        end
end
