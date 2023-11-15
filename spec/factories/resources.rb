FactoryBot.define do
  factory :resource do
    name { "Widgets" }
    schema {
      {
        required:   %w[
          id
          name
        ],
        properties: {
          id:   {
            type:        "integer",
            format:      "int64",
            description: "blah blah"
          },
          name: {
            type:        "string",
            description: "blah blah"
          },
          tag:  {
            type:        "string",
            description: "blah blah"
          }
        }
      }
    }
  end
end
