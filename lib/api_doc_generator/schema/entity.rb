module ApiDocGenerator::Schema
  class Entity < Base

    attr_accessor :output, :generator, :indent,
      :source, :path, :root, :data, :properties, :spaces

    def initialize(generator, source, indent)
      @output = []
      @generator = generator
      @indent = indent
      @root = get_root(source)
      @path = get_path(source)
      @data = fetch_data(source)

      @properties = Properties.new(generator, indent)
    end

    def render
      get_entity_output(data)
      output << properties.render
      output.join("\n")
    end

  private

    def fetch_data(source)
      local_root = get_root(source)
      local_path = get_path(source)
      parse_json(local_path)[local_root]
    end

    def get_entity_output(data)
      if data["properties"].present?
        properties.add(data["properties"])
      elsif data["$ref"].present?
        get_ref_data(data["$ref"])
      elsif data["allOf"].present?
        get_all_of_data(data["allOf"])
      end
    end

    def get_all_of_data(all_of)
      all_of.map { |entity| get_entity_output(entity) }
    end

    def get_ref_data(ref)
      ref = path + ref if ref =~ /^#/
      data = fetch_data(ref)
      get_entity_output(data)
    end

    def get_root(source)
      source[/#\/(.*)$/, 1]
    end

    def get_path(source)
      source.gsub(/#\/(.*)$/, "")
    end

  end
end
