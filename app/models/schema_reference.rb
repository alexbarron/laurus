class SchemaReference < ApplicationRecord
  belongs_to :endpoint, optional: true
  belongs_to :parent_schema, optional: true, class_name: "Schema", foreign_key: :referenced_id
  belongs_to :child_schema, optional: true, class_name: "Schema", foreign_key: :schema_id
end
