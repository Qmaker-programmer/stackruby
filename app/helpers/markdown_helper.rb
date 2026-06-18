require 'kramdown'

module MarkdownHelper
  def markdown_to_html(text)
    return "" if text.blank?

    # Configuración de Kramdown
    options = {
      input: 'GFM',                    # GitHub Flavored Markdown
      hard_wrap: true,                 # Saltos de línea reales
      syntax_highlighter: nil,         # Sin resaltado (para mantener simple)
      remove_block_html_tags: false,   # Permitir HTML
      auto_ids: false                  # No generar IDs automáticos
    }

    Kramdown::Document.new(text, options).to_html.html_safe
  end
end
