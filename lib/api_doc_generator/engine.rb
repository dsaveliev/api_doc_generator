module ApiDocGenerator
  class Engine < ::Rails::Engine
    isolate_namespace ApiDocGenerator

    config.to_prepare do
      ApplicationController.helper(ApiDocGenerator::ApplicationHelper)
    end

    config.autoload_paths += %W(#{config.root}/lib)

  end
end
