class DeveloperApp < ApplicationRecord
    has_many :app_memberships, foreign_key: :developer_app_id
    has_many :members, through: :app_memberships, source: :user
    has_many :grants
    has_many :endpoints, through: :grants
    has_many :app_invitations
    has_paper_trail skip: [:id, :created_at, :updated_at]

    before_create :generate_client_id

    validates :name, presence: true, length: { maximum: 50, minimum: 3 }

    def archive
        self.archived_at = Time.now
        self.save!
    end

    def unarchive
        self.archived_at = nil
        self.save!
    end

    private

        def generate_client_id
            self.client_id = SecureRandom.base64(16)
        end
end
