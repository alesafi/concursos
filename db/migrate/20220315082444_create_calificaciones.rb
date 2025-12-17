class CreateCalificaciones < ActiveRecord::Migration[5.1]
  def change
    create_table :calificaciones do |t|
	    t.integer :calificacion
      t.integer :media_id, :null => true
      t.integer :usuario_id

      t.timestamps
    end
  end
end
