namespace :api_doc_generator do

  desc 'Generate Markdown description'
  task markdown: :environment do
    ApiDocGenerator::Schema::Generator.new.render
  end

end
