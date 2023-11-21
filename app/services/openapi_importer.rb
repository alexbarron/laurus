class OpenAPIImporter
  attr_reader :spec

  def initialize(spec)
    @spec = spec
  end

  def import
    parsed_spec = OpenAPIParser.parse(YAML.load_file(spec))
    parsed_spec.paths.raw_schema.each do |path, methods|
      import_endpoints(path, methods)
    end
  end

  private

  def import_endpoints(path, methods)
    methods.each do |method, properties|
      endpoint = Endpoint.find_or_create_by(path: path, method: method.upcase, description: properties["summary"])
      import_parameters(endpoint, properties["parameters"])
    end
  end

  def import_parameters(endpoint, parameters)
    parameters&.each do |parameter|
      parameter = Parameter.find_or_create_by(name:      parameter["name"],
                                              location:  parameter["in"],
                                              data_type: parameter["schema"]["type"])
      endpoint.parameters << parameter unless endpoint.parameters.include?(parameter)
    end
  end
end
