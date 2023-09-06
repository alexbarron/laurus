class Endpoint < ApplicationRecord
    validates :path, presence: true, uniqueness: { scope: :method, message: "and method pair already exists" }
    validates :method, presence: true, inclusion: { in: %w[GET POST PUT PATCH DELETE] }
end
