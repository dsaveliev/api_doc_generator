module ApiDocGenerator

  class SchemaController < ApplicationController

    def index
      @data = File.read("#{Rails.root}/public/schema.md")
    end

  end
end