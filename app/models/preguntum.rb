class Preguntum < ApplicationRecord
  belongs_to :usuario
  
  # MODIFICADO: Al borrar la pregunta se eliminan todos sus comentarios hilos/hijos
  has_many :comentarios, dependent: :destroy
  
  # MODIFICADO: Cambiamos el nombre a :registro_votos para no chocar con el entero :votos
  has_many :registro_votos, class_name: 'Voto', dependent: :destroy

  validates :titulo, :cuerpo, presence: true
  before_create :poner_votos_en_cero
  
  # Callback para ajustar las estadísticas de los usuarios antes de borrar
  before_destroy :descontar_votos_a_usuarios

  private

  def poner_votos_en_cero
    self.votos = 0
  end

  # Lógica para limpiar el historial de votación de los usuarios
  def descontar_votos_a_usuarios
    # Ahora iteramos sobre la relación usando el nuevo nombre
    self.registro_votos.each do |voto|
      usuario_que_voto = voto.usuario
      next unless usuario_que_voto.present?

      if usuario_que_voto.respond_to?(:votos_totales)
        usuario_que_voto.decrement!(:votos_totales) 
      end
    end
  end
end