class SchemaReference < ApplicationRecord
  belongs_to :endpoint, optional: true
  belongs_to :parent, optional: true, class_name: "Schema", foreign_key: :referenced_id
  belongs_to :dependent, optional: true, class_name: "Schema", foreign_key: :schema_id
end
