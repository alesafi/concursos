class MosaicoNatura::MediaMn < Media
	
	#attr_accessor :filename
	FECHA_TERMINO_INICIAL = Date.new(2022, 01, 16)
	
	belongs_to :usuario, class_name: "UsuarioMn"
	has_one :direccion, through: :usuario, source: :direccion
	has_one :user, through: :usuario, source: :user

	belongs_to :categoria, class_name: "CategoriaMn"
	has_one :media_metadato, inverse_of: :media, foreign_key: :media_id, class_name: "MediaMetadatoMn", dependent: :destroy
	accepts_nested_attributes_for :media_metadato, allow_destroy: true

	has_many :calificaciones, inverse_of: :media, foreign_key: :media_id, class_name: "CalificacionMn"
	
	validates_presence_of :original_filename, :categoria_id

	mount_uploader :original_filename, MediaAwsUploader
	
	scope :mosaico, -> { where(categoria: (1..9))}
	scope :where_fotos, -> { where('posicion IS NULL').where('usuarios.concurso_id' => 2) }
	
	
	scope :select_medias, -> { select(:id, "original_filename as archivo_original", :filename,  'media_metadatos.titulo', :descripcion, :marca, :localidad, :otra_marca, :calificacion, :usuario_id, "usuarios.fecha_nacimiento", :categoria_id, :created_at, :nombre_categoria) }
	scope :select_promedio_fotos, -> { select("(substr(cast(calificacion as char),1,1) + substr(cast(calificacion as char),2,1) + substr(cast(calificacion as char),3,1) + substr(cast(calificacion as char),4,1))/4 as promedio") }
	scope :select_promedio_videos, -> { select("(substr(cast(calificacion as char),1,1) + substr(cast(calificacion as char),2,1))/2 as promedio") }
	scope :select_promedio_comparativo_fotos, -> { select_promedio_fotos.select("(substr(cast(calificacion as char),2,1) + substr(cast(calificacion as char),3,1) + substr(cast(calificacion as char),4,1))/3 as promedio_sin_juez01", "(substr(cast(calificacion as char),1,1) + substr(cast(calificacion as char),3,1) + substr(cast(calificacion as char),4,1))/3 as promedio_sin_juez02", "(substr(cast(calificacion as char),1,1) + substr(cast(calificacion as char),2,1) + substr(cast(calificacion as char),4,1))/3 as promedio_sin_juez03", "(substr(cast(calificacion as char),1,1) + substr(cast(calificacion as char),2,1) + substr(cast(calificacion as char),3,1))/3 as promedio_sin_juez04") }
	scope :select_promedio_comparativo_videos, -> { select_promedio_videos.select("substr(cast(calificacion as char),2,1) as promedio_sin_juez01", "substr(cast(calificacion as char),1,1) as promedio_sin_juez02", "'' as promedio_sin_juez03", "'' as promedio_sin_juez04")  }
	scope :select_datos_usuario, -> { select("usuarios.nombre", "usuarios.apellido_paterno", "usuarios.apellido_materno")}
	scope :select_datos_direccion, -> { select(:calle, :numero, :interior, :colonia, :municipio, :cp, :estado) }
	
	scope :select_ganadores, -> { select_medias.select_datos_usuario.select(:estado, :municipio).select("substr(cast(calificacion as char),5,1) as lugar")}
	scope :select_todo, -> { select_medias.select_datos_usuario.select_datos_direccion.select("substr(cast(calificacion as char),5,1) as lugar").select( :email, "usuarios.medio", "usuarios.otro_medio" ) }
	
	scope :joins_con_calificacion, -> { joins(:media_metadato, :categoria, :usuario).left_joins(:calificaciones) }
	scope :joins_con_calificacion_direccion, -> { joins_con_calificacion.joins(:direccion) }
	
	scope :finalistas, -> { select_medias.joins_con_calificacion.where_fotos }
	scope :desempate_foto, -> { select_medias.select_promedio_comparativo_fotos.joins_con_calificacion.where('categoria_id != 8').order('lugar ASC, promedio DESC') }
	scope :desempate_video, -> { select_medias.select_promedio_comparativo_videos.joins_con_calificacion.where('categoria_id' => 8).order('lugar ASC, promedio DESC') }
	scope :desempate_foto_con_datos, -> { select_ganadores.select_promedio_comparativo_fotos.joins_con_calificacion_direccion.where('categoria_id != 8').order('promedio DESC') }
	scope :desempate_video_con_datos, -> { select_ganadores.select_promedio_comparativo_videos.joins_con_calificacion_direccion.where('categoria_id' => 8).order('promedio DESC') }
	
	scope :ganadores, -> { select_ganadores.joins_con_calificacion_direccion.where_fotos.where("calificacion not like '%0'").order("categoria_id ASC, lugar ASC") }
	
	scope :todo_de_todos, -> { select_todo.left_joins(:media_metadato, :categoria, :user, :direccion, :calificaciones).where_fotos }
	

	def filename
		[self.usuario_id, self.categoria_id, self.id, self.created_at.strftime('%Y%m%d%H%M%S'),dame_extension(self.archivo_original)].join('_')
	end
	
	def genera_filename_anonimo
		filename
	end
	
	def age_in_completed_years(bd)
		# Difference in years, less one if you have not had a birthday this year.
		a = FECHA_TERMINO_INICIAL.year - bd.year
		a = a - 1 if (
		bd.month > FECHA_TERMINO_INICIAL.month or
				(bd.month >= FECHA_TERMINO_INICIAL.month and bd.day > FECHA_TERMINO_INICIAL.day)
		)
		a
	end
	
	def edad
		age_in_completed_years(self.fecha_nacimiento)
	end
	
end
