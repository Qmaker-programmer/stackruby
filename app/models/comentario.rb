class Comentario < ApplicationRecord
  belongs_to :usuario, optional: true
  belongs_to :preguntum

  belongs_to :padre, class_name: "Comentario", foreign_key: "comentario_padre_id", optional: true
  has_many :hijos, class_name: "Comentario", foreign_key: "comentario_padre_id", dependent: :destroy

  validates :cuerpo, presence: true

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

  # Recolector en cascada reversa: Limpia padres fantasmas vacíos
  def recolector_fantasmas_reverso
    return unless padre.present?
    if padre.fantasma? && padre.hijos.empty?
      padre.destroy
    end
  end
end
