class MosaicoNatura::CalificacionMn < Calificacion

    belongs_to :usuario, class_name: "UsuarioMn"
    belongs_to :media, class_name: "MediaMn"
    validates_presence_of :calificacion, :media_id, :usuario_id

end