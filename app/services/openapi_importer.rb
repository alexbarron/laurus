class OpenAPIImporter
  attr_reader :parsed_spec

  def initialize(spec_file)
    @parsed_spec = OpenAPIParser.parse(YAML.load_file(spec_file))
  end

  def import
    parsed_spec.paths.raw_schema.each do |path, methods|
      import_endpoints(path, methods)
    end
  end

  private

  def import_endpoints(path, methods)
    methods.each do |method, properties|
      endpoint = Endpoint.find_or_create_by(path:        path,
                                            method:      method.upcase,
                                            description: properties["summary"])
      import_parameters(endpoint, properties["parameters"])
    end
  end

  def import_parameters(endpoint, parameters)
    parameters&.each do |parameter|
      if parameter.key?("$ref")
        parameter = Parameter.find_or_create_by(find_referenced_parameter(parameter))
      elsif parameter.key?("name")
        parameter = Parameter.find_or_create_by(name:      parameter["name"],
                                                location:  parameter["in"],
                                                data_type: parameter["schema"]["type"])
      end
      endpoint.parameters << parameter unless endpoint.parameters.include?(parameter)
    end
  end

  def find_referenced_parameter(parameter)
    name = parameter["$ref"].split("/").last
    {
      name:      name,
      location:  parsed_spec.components.parameters[name].in,
      data_type: parsed_spec.components.parameters[name].schema.type
    }
  end
end
