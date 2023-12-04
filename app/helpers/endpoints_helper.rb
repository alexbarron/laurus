module EndpointsHelper
  def render_response_body_schema(body)
    return unless renderable?(body)

    result = html_escape("")
    result << content_tag(:pre, json_schema(body["content"]["application/json"]["schema"]))
  end

  private

  def renderable?(body)
    !body["content"].nil? && body["content"].has_key?("application/json") && has_schema_ref?(body)
  end

  def has_schema_ref?(body)
    body["content"]["application/json"]["schema"]["$ref"] || body["content"]["application/json"]["schema"]["items"].try(:[], :$ref)
  end

  def json_schema(schema_ref)
    schema = @endpoint.dependent_schemas.where(name: schema_name(schema_ref)).first.properties_with_dependents
    JSON.pretty_generate(schema)
  end

  def schema_name(schema_ref)
    schema_path = schema_ref["$ref"] || schema_ref["items"]["$ref"]
    schema_path.split("/").last
  end
end
