Rails.application.routes.draw do

  mount ApiDocGenerator::Engine => "/api_doc_generator"
end
