module ApiDocGenerator::Schema
  class Generator < Base

    def render
      output = render_index("index")
      File.write("#{Rails.root}/public/#{FILE_NAME}", output)
    end

    def render_index(source)
      data = parse_json(source)

      output = []
      output << "## Общие ошибки\n"
      output << render_errors(data)
      data["properties"].values.each do |chapter|
        output << "## #{chapter["title"]}\n"
        chapter["properties"].values.each do |action|
          output << render_action(action["$ref"])
        end
      end
      output.join("\n")
    end

    def render_section(data = {})
      output = []
      output << "## #{data["title"]}\n"
      data["properties"].values.each do |action|
        output << render_action(action["$ref"])
      end
      output.join("\n")
    end

    def render_action(source)
      data = parse_json(source)

      output = []
      output << "### #{data["title"]}\n"
      output << render_request(data)
      output << "#### Ошибки\n"
      output << render_errors(data)
      output << render_response(data)
      output << "***"
      output.join("\n")
    end

    def escape_string(value)
      value.to_s.gsub("_", "\\_")
    end

    def render_request(data = {})
      output = []
      data = data["links"]
      data.each do |link|
        output << "```"
        output << "#{link["method"]} #{link["href"]}"
        output << "```\n"
        output << "#### Параметры\n"
        if link["schema"].present?
          output << "| Название | Тип | Пример |"
          output << "| ------- | ------- | ------- |"
          link["schema"]["properties"].each do |key, value|
            escaped_key   = escape_string(key)
            escaped_type  = escape_string(value["type"])
            escaped_value = escape_string(value["example"])
            wrapped_value = wrap_value(escaped_type, escaped_value)
            output << "|**#{escaped_key}**|*#{escaped_type}*|#{wrapped_value}|"
          end
        else
          output << "Отсутствуют\n"
        end
        output << "\n"
      end
      output.join("\n")
    end

    def render_errors(data = {})
      output = []
      if data["errors"].present?
        data["errors"].each_pair do |key, errors|
          errors.each do |error|
            output << "```"
            output << JSON.pretty_generate(error)
            output << "```\n"
          end
        end
      else
        output << "Отсутствуют\n"
      end
      output.join("\n")
    end

    def render_response(data = {})
      output = []
      output << "#### Пример ответа\n"
      output << "```"
      output << HTTP_OK
      if data["properties"].present?
        output << Properties.new(self, INDENT_START).add(data["properties"]).render
      elsif data["$ref"].present?
        output << Entity.new(self, data["$ref"], INDENT_START).render
      elsif data["type"].present? && data["type"] == "array"
        output << Entities.new(self, data["items"]["$ref"], INDENT_START).render
      else
        output << "{}"
      end
      output << "```"
      output.join("\n")
    end

  end
end
