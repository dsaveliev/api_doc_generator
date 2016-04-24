module ApiDocGenerator::Schema
  class Base

    HTTP_OK = "HTTP/1.1 200 OK"
    INDENT_STEP = 2
    INDENT_START = 0
    FILE_NAME = "schema.md"

    def parse_json(path)
      path.gsub!(".json", "")
      path.gsub!("../", "")
      path.gsub!("./", "")

      path = "#{Rails.root}/schemas/#{path}.json"
      json = File.read(path)
      JSON.parse(json)
    end

    def wrap_value(types, value)
      types = Array(types)
      non_quotable_types = ["integer", "number", "boolean", "null"]

      if (types & non_quotable_types).present?
        value
      else
        "\"#{value}\""
      end
    end

  end
end
