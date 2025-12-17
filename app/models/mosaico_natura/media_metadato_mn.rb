class MosaicoNatura::MediaMetadatoMn < MediaMetadato
	
	MARCA = [['Canon','canon'],['Nikon','nikon'],['Olympus','olympus'],['Sony','sony'],['Fuji','fuji'],['Panasonic','panasonic'],['Otro','otro']]
	
	belongs_to :media, class_name: "MediaMn"
	validates_presence_of :titulo, :descripcion, :marca, :localidad

end
