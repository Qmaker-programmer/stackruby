class Comentario < ApplicationRecord
  belongs_to :usuario, optional: true
  belongs_to :preguntum
  
  belongs_to :padre, class_name: "Comentario", foreign_key: "comentario_padre_id", optional: true
  has_many :hijos, class_name: "Comentario", foreign_key: "comentario_padre_id", dependent: :destroy

  # Relación con la tabla física de votos (asumiendo que tu modelo se llama Voto)
  # Si tu tabla de votos guarda el comentario_id, se destruyen en cascada
  

  validates :cuerpo, presence: true
  before_create :poner_votos_en_cero
  
  # CALLBACKS: Limpiar estadísticas del autor antes de la destrucción física total
  before_destroy :limpiar_votos_del_autor

  def eliminar_con_poda!
    # 1. Antes de alterar el comentario, le restamos sus votos acumulados al autor
    descontar_votos_del_perfil(self.votos) if self.usuario.present?

    # 2. Procedemos con la bifurcación del algoritmo de poda
    if hijos.any?
      # Soft-delete: Pasa a ser fantasma, pierde sus votos y se desvincula del autor
      update(cuerpo: "[Este comentario fue eliminado]", usuario_id: nil, votos: 0)
      # Limpiamos físicamente los registros de la tabla de votos para este comentario
      registro_votos.destroy_all
    else
      # Purga física instantánea si no tiene descendencia
      destroy
    end
  end

  def fantasma?
    usuario_id.nil? && cuerpo == "[Este comentario fue eliminado]"
  end

  private

  def poner_votos_en_cero
    self.votos = 0
  end

  # Limpieza para cuando el comentario se destruye físicamente de la BD
  def limpiar_votos_del_autor
    return unless usuario.present?
    descontar_votos_del_perfil(self.votos)
  end

  # Método auxiliar para actualizar el contador del perfil del Usuario de forma masiva
  def descontar_votos_del_perfil(cantidad_votos)
    return if cantidad_votos == 0
    
    # Verificamos si tu modelo Usuario tiene una columna para acumular la reputación/votos recibidos
    if Usuario.column_names.include?('votos_totales')
      usuario.decrement!(:votos_totales, cantidad_votos)
    elsif Usuario.column_names.include?('reputacion')
      usuario.decrement!(:reputacion, cantidad_votos)
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
