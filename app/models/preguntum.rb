class Preguntum < ApplicationRecord
  belongs_to :usuario, optional: true
  
  # ¡ESTA ES LA LÍNEA QUE FALTA!
  has_many :comentarios, dependent: :destroy

  validates :titulo, :cuerpo, presence: true
  before_create :poner_votos_en_cero

  private
  def poner_votos_en_cero
    self.votos = 0
  end
end
