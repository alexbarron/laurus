class OpenAPIImporter
  attr_reader :parsed_spec

  def initialize(spec_file)
    @parsed_spec = OpenAPIParser.parse(YAML.load_file(spec_file))
  end

  def import
    import_schemas
    import_schema_refs
    import_paths
  end

  def import_schemas
    parsed_spec.components.schemas.each do |name, attributes|
      Schema.find_or_initialize_by(name: name).update(
        properties:  attributes.raw_schema["properties"],
        title:       attributes.title,
        data_type:   attributes.type,
        description: attributes.description
      )
    end
  end

  def import_paths
    parsed_spec.paths.raw_schema.each do |path, methods|
      import_endpoint(path, methods)
    end
  end

  def import_schema_refs
    parsed_spec.components.schemas.each do |name, attributes|
      parent_schema = Schema.where(name: name).first

      combo_schemas(attributes.raw_schema, parent_schema)
      property_schemas(attributes.raw_schema["properties"], parent_schema)
    end
  end

  private

  def import_endpoint(path, methods)
    methods.each do |method, properties|
      endpoint = Endpoint.find_or_initialize_by(path: path, method: method.upcase)
      endpoint.update(description: properties["summary"])
      import_parameters(endpoint, properties["parameters"])
    end
  end

  def combo_schemas(raw_schema, parent_schema)
    if raw_schema.has_key?("allOf")
      raw_schema["allOf"].each do |ref|
        import_schema_reference(ref["$ref"], parent_schema)
      end
    elsif raw_schema.has_key?("anyOf")
      raw_schema["anyOf"].each do |ref|
        import_schema_reference(ref["$ref"], parent_schema)
      end
    elsif raw_schema.has_key?("oneOf")
      raw_schema["oneOf"].each do |ref|
        import_schema_reference(ref["$ref"], parent_schema)
      end
    end
  end

  def property_schemas(properties, parent_schema)
    properties.each do |_property, data|
      if data.has_key?("$ref")
        import_schema_reference(data["$ref"], parent_schema)
      elsif data["type"] == "array" && data["items"].has_key?("$ref")
        import_schema_reference(data["items"]["$ref"], parent_schema)
      end
    end
  end

  def import_schema_reference(child_schema_path, parent_schema)
    child_schema_name = child_schema_path.split("/").last
    child_schema = Schema.where(name: child_schema_name).first
    SchemaReference.find_or_create_by(referenced_id: child_schema.id, schema_id: parent_schema.id)
  end

  def import_parameters(endpoint, parameters)
    parameters&.each do |openapi_parameter|
      if openapi_parameter.key?("$ref")
        parameter_attributes = find_referenced_parameter(openapi_parameter)
        description = parameter_attributes.delete(:description)
        parameter = component_parameter(parameter_attributes)
      elsif openapi_parameter.key?("name")
        description = openapi_parameter["description"]
        parameter = path_parameter(openapi_parameter)
      end
      endpoint.parameter_references.find_or_initialize_by(parameter_id: parameter.id).update(description: description)
    end
  end

  def component_parameter(parameter_attributes)
    parameter = Parameter.find_or_initialize_by(name: parameter_attributes[:name])
    parameter.update(parameter_attributes)
    parameter
  end

  def path_parameter(openapi_parameter)
    parameter = Parameter.find_or_initialize_by(name: openapi_parameter["name"])
    parameter.update(location: openapi_parameter["in"], data_type: openapi_parameter["schema"]["type"])
    parameter
  end

  def find_referenced_parameter(parameter)
    name = parameter["$ref"].split("/").last
    {
      name:        name,
      location:    parsed_spec.components.parameters[name].in,
      data_type:   parsed_spec.components.parameters[name].schema.type,
      description: parsed_spec.components.parameters[name].description
    }
  end
end
