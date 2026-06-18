class AddMarkdownToPreguntaAndComentarios < ActiveRecord::Migration[6.1]
  def change
    # Para preguntas: guardamos el markdown original y el HTML procesado
    add_column :pregunta, :cuerpo_markdown, :text
    add_column :pregunta, :cuerpo_html, :text

    # Para comentarios también
    add_column :comentarios, :cuerpo_markdown, :text
    add_column :comentarios, :cuerpo_html, :text

    # Migrar datos existentes: copiar 'cuerpo' a 'cuerpo_markdown' y generar HTML básico
    reversible do |dir|
      dir.up do
        # Migramos preguntas existentes
        execute <<-SQL
          UPDATE pregunta
          SET cuerpo_markdown = cuerpo,
              cuerpo_html = cuerpo
          WHERE cuerpo_markdown IS NULL
        SQL

        # Migramos comentarios existentes
        execute <<-SQL
          UPDATE comentarios
          SET cuerpo_markdown = cuerpo,
              cuerpo_html = cuerpo
          WHERE cuerpo_markdown IS NULL
        SQL
      end
    end
  end
end
