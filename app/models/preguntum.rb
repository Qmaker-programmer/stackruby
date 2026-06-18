class Preguntum < ApplicationRecord
  belongs_to :usuario

  # MODIFICADO: Al borrar la pregunta se eliminan todos sus comentarios hilos/hijos
  has_many :comentarios, dependent: :destroy

  # Sistema de estrellas: Una pregunta puede tener muchas estrellas
  has_many :estrellas, dependent: :destroy
  has_many :usuarios_que_dieron_estrella, through: :estrellas, source: :usuario

  validates :titulo, :cuerpo, presence: true
  before_create :inicializar_contadores

  # Método para contar cuántas estrellas tiene esta pregunta
  def total_estrellas
    estrellas.count
  end

  # Método para verificar si un usuario específico le dio estrella
  def tiene_estrella_de?(usuario)
    return false unless usuario
    estrellas.exists?(usuario_id: usuario.id)
  end

  # Método para incrementar las vistas
  def incrementar_vista!
    increment!(:vistas)
  end

  private

  def inicializar_contadores
    self.votos ||= 0
    self.vistas ||= 0 if self.respond_to?(:vistas=)
  end
end
