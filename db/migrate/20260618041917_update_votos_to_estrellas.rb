class UpdateVotosToEstrellas < ActiveRecord::Migration[6.1]
  def change
    # Eliminar la columna 'tipo' (ya no necesitamos "arriba" o "abajo")
    remove_column :votos, :tipo, :string

    # Agregar columna comentario_id (pero dejaremos en null los comentarios)
    add_column :votos, :comentario_id, :integer

    # Renombrar tabla votos a estrellas para mayor claridad
    rename_table :votos, :estrellas

    # Agregar columna de vistas a las preguntas
    add_column :pregunta, :vistas, :integer, default: 0

    # Eliminar la columna votos de comentarios (ya no se votarán)
    remove_column :comentarios, :votos, :integer
  end
end
