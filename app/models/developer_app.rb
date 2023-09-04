class DeveloperApp < ApplicationRecord
    before_create :generate_client_id

    private

        def generate_client_id
            self.client_id = SecureRandom.base64(16)
        end
end
