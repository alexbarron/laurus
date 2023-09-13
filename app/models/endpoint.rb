class Endpoint < ApplicationRecord
    has_many :grants
    has_many :developer_apps, through: :grants

    validates :path, presence: true, uniqueness: { scope: :method, message: "and method pair already exists" }
    validates :method, presence: true, inclusion: { in: %w[GET POST PUT PATCH DELETE] }

    scope :ordered_by_path, -> { order(path: :asc, method: :asc) }
end