class Comentario < ApplicationRecord
  belongs_to :usuario, optional: true
  belongs_to :preguntum

  belongs_to :padre, class_name: "Comentario", foreign_key: "comentario_padre_id", optional: true
  has_many :hijos, class_name: "Comentario", foreign_key: "comentario_padre_id", dependent: :destroy

  validates :cuerpo_markdown, presence: true
  before_save :procesar_markdown

  def eliminar_con_poda!
    # Procedemos con la bifurcación del algoritmo de poda
    if hijos.any?
      # Soft-delete: Pasa a ser fantasma y se desvincula del autor
      update(cuerpo: "[Este comentario fue eliminado]", usuario_id: nil)
    else
      # Purga física instantánea si no tiene descendencia
      destroy
    end
  end

  def fantasma?
    usuario_id.nil? && cuerpo == "[Este comentario fue eliminado]"
  end

  private

  def procesar_markdown
    if cuerpo_markdown_changed?
      require 'kramdown'
      options = {
        input: 'GFM',
        hard_wrap: true,
        parse_block_html: true,
        parse_span_html: true
      }
      self.cuerpo_html = Kramdown::Document.new(cuerpo_markdown, options).to_html
      # Mantenemos 'cuerpo' sincronizado
      self.cuerpo = cuerpo_markdown
    end
  end

  # Recolector en cascada reversa: Limpia padres fantasmas vacíos
  def recolector_fantasmas_reverso
    return unless padre.present?
    if padre.fantasma? && padre.hijos.empty?
      padre.destroy
    end
  end
end
