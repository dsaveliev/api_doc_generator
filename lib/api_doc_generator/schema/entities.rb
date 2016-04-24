module ApiDocGenerator::Schema
  class Entities < Entity

    attr_accessor :spaces

    def initialize(generator, source, indent)
      super(generator, source, indent + INDENT_STEP)
      @spaces = " " * indent
    end

    def render
      get_entity_output(data)
      output << spaces + "["
      output << spaces + properties.render(keyless: true)
      output << spaces + "]"
      output.join("\n")
    end

  end
end
