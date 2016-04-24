module ApiDocGenerator::Schema
  class Properties < Base

    attr_accessor :output, :data, :indent, :generator, :spaces, :properties_collection

    def initialize(generator, indent)
      @output = []
      @properties_collection = []
      @generator = generator
      @indent = indent
      @spaces = " " * indent
    end

    def render(keyless: false)
      output << (keyless ? "#{spaces}{" : "{")
      output << properties_collection.join(",\n") if properties_collection.present?
      output << "#{spaces}}"
      output.join("\n")
    end

    def add(properties)
      properties.each do |key, value|
        if value["type"].present? && value["example"].present?
          wrapped_value = wrap_value(value["type"], value["example"])
          properties_collection << render_example(key, wrapped_value)
        elsif value["$ref"].present?
          properties_collection << render_ref(key, value)
        elsif value["type"].present? && value["type"] == "array"
          properties_collection << render_array_of_entities(key, value)
        elsif value["type"].present? && value["type"] == "object"
          properties_collection << render_properties(key, value)
        end
      end
      self
    end

  private

    def render_example(key, value)
      "#{spaces}  \"#{key}\": #{value}"
    end

    def render_ref(key, value)
      ref = value["$ref"]
      entity = Entity.new(generator, ref, indent + INDENT_STEP).render
      "#{spaces}  \"#{key}\": #{entity}"
    end

    def render_array_of_entities(key, value)
      local_indent = indent + INDENT_STEP
      local_spaces = " " * local_indent

      entity = if value["items"]["$ref"].present?
        ref = value["items"]["$ref"]
        Entity.new(generator, ref, local_indent + INDENT_STEP).render
      elsif value["items"]["example"].present?
        "\"#{value["items"]["example"]}\""
      end

      local_output = []
      local_output << "["
      local_output << "#{local_spaces}  #{entity}"
      local_output << "#{local_spaces}]"
      entities = local_output.join("\n")

      "#{spaces}  \"#{key}\": #{entities}"
    end

    def render_properties(key, value)
      properties = value["properties"]
      properties = Properties.new(generator, indent + INDENT_STEP).add(properties).render

      "#{spaces}  \"#{key}\": #{properties}"
    end

  end
end
