module ApiDocGenerator

  class BootstrapTables < Redcarpet::Render::HTML
    def table(header, body)
      "\n<table class='table table-striped table-bordered table-condensed'><thead>\n#{ header }</thead><tbody>\n#{ body }</tbody></table>\n"
    end
  end
end