class CreatePregunta < ActiveRecord::Migration[6.1]
  def change
    create_table :pregunta do |t|
      t.string :titulo
      t.text :cuerpo
      t.integer :votos

      t.timestamps
    end
  end
end
