class MediaMetadatoAyv < MediaMetadato
	
	belongs_to :media, class_name: "MediaAyv"
	belongs_to :usuario
	validates_presence_of :titulo, :descripcion, :tecnica, :compromiso

end
