class CalificacionAyv < Calificacion

    belongs_to :usuario, class_name: "UsuarioAyv"
    belongs_to :media, class_name: "MediaAyv"
    validates_presence_of :calificacion, :media_id, :usuario_id

end