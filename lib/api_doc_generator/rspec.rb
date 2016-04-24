require 'api_doc_generator/rspec/matchers'

RSpec.configure do |config|
  config.before(:all) do
    schema_directory = "#{Rails.root}/schemas/entities/**/*.json"
    Dir.glob(schema_directory) do |schema_path|
      JSON::Validator.validate!(schema_path, "", strict: true)
    end
  end
end

