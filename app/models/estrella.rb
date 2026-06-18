class Estrella < ApplicationRecord
  belongs_to :usuario
  belongs_to :preguntum

  # Validación: un usuario solo puede dar una estrella por pregunta
  validates :usuario_id, uniqueness: { scope: :preguntum_id, message: "Ya diste una estrella a esta pregunta" }
end
