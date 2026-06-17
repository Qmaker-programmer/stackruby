class CreateComentarios < ActiveRecord::Migration[6.1]
  def change
    create_table :comentarios do |t|
      t.text :cuerpo
      t.integer :votos
      t.integer :usuario_id
      t.integer :preguntum_id
      t.integer :comentario_padre_id

      t.timestamps
    end
  end
end
