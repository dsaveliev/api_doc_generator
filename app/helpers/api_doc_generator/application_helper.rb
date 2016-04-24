module ApiDocGenerator
  module ApplicationHelper
    def markdown(text)
      options = {
        filter_html: true,
        with_toc_data: true
      }

      extensions = {
        tables:             true,
        highlight:          true,
        disable_indented_code_blocks: true,
        fenced_code_blocks: true
      }

      renderer = BootstrapTables.new(options)
      markdown = Redcarpet::Markdown.new(renderer, extensions)

      markdown.render(text).html_safe
    end

    def markdown_toc(text)
      options = {
        filter_html: true,
        nesting_level: 3
      }

      extensions = {
        tables:             true,
        highlight:          true,
        disable_indented_code_blocks: true,
        fenced_code_blocks: true
      }

      renderer_toc = Redcarpet::Render::HTML_TOC.new(options)
      markdown_toc = Redcarpet::Markdown.new(renderer_toc, extensions)

      markdown_toc.render(text).html_safe
    end
  end
end
