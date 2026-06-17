class Comentario < ApplicationRecord
  belongs_to :usuario
  belongs_to :preguntum
  
  # La magia auto-referencial:
  belongs_to :padre, class_name: "Comentario", foreign_key: "comentario_padre_id", optional: true
  has_many :hijos, class_name: "Comentario", foreign_key: "comentario_padre_id", dependent: :destroy

  validates :cuerpo, presence: true
  before_create :poner_votos_en_cero

  private
  def poner_votos_en_cero
    self.votos = 0
  end
end
