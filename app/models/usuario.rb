require 'bcrypt'

class Usuario < ApplicationRecord
  # MODIFICADO: Se añade dependent: :destroy a ambas relaciones
  has_many :pregunta, dependent: :destroy
  has_many :comentarios, dependent: :destroy

  # Sistema de estrellas
  has_many :estrellas, dependent: :destroy
  has_many :preguntas_favoritas, through: :estrellas, source: :preguntum

  validates :nombre, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 3 }
  validates :contrasena, presence: true, length: { minimum: 6 }

  # EFECTO ENCRIPTAR: Antes de guardar en la base de datos, encriptamos la contraseña
  before_save :encriptar_contrasena, if: :will_save_change_to_contrasena?

  # Método para verificar si la contraseña ingresada coincide con el hash encriptado
  def contrasena_valida?(password_ingresado)
    BCrypt::Password.new(self.contrasena) == password_ingresado
  rescue BCrypt::Errors::InvalidHash
    # Por si acaso quedaron contraseñas viejas en texto plano sin encriptar
    self.contrasena == password_ingresado
  end

  # Estadísticas de estrellas
  def total_estrellas_otorgadas
    estrellas.count
  end

  def total_estrellas_recibidas
    Estrella.joins(:preguntum).where(pregunta: { usuario_id: self.id }).count
  end

  private

  def encriptar_contrasena
    self.contrasena = BCrypt::Password.create(self.contrasena)
  end
end
