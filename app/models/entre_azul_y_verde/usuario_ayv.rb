class UsuarioAyv < Usuario
	
	CONCURSO = "ayv".freeze
	MEDIO = [["Redes sociales", "redes-sociales"], ["Radio", "radio"], ["Televisión", "television"], ["En la escuela", "escuela"], ["Otro", "otro"]]
	FECHA_NAC_MIN = "2003-01-01"
	FECHA_NAC_MAX = "2016-01-01"
	FECHA_TERMINO = Date.new(2022,02,28)

	#alias_attribute :edad, :edad

	validates_presence_of :nombre, :apellido_paterno, :apellido_materno, :fecha_nacimiento, :lugar_nacimiento, :medio
	#validates_presence_of :nombre
	
	has_one :direccion, inverse_of: :usuario, foreign_key: :usuario_id, class_name: "DireccionAyv", dependent: :destroy
	accepts_nested_attributes_for :direccion, allow_destroy: true
	
	has_one :tutor, inverse_of: :usuario, foreign_key: :usuario_id, class_name: "TutorAyv", dependent: :destroy
	accepts_nested_attributes_for :tutor, allow_destroy: true
	
	has_many :media, -> { order("posicion ASC") }, inverse_of: :usuario, foreign_key: :usuario_id, class_name: "MediaAyv", dependent: :destroy
	accepts_nested_attributes_for :media, allow_destroy: true
	
	has_many :media_bis, inverse_of: :usuario, foreign_key: :usuario_id, class_name: "MediaAyv"
	
	has_many :media_metadato, through: :media_bis, source: :media_metadato

	has_many :calificaciones, inverse_of: :usuario, foreign_key: :usuario_id, class_name: "CalificacionAyv"
	
	scope :select_dibujo, -> { select(:id, :fecha_nacimiento, "medias.id as media1_id", "medias.original_filename as proceso", "media_bis_usuarios_join.id as media2_id", "media_bis_usuarios_join.original_filename as terminado", "media_metadatos.titulo", :descripcion, :tecnica, :compromiso, :calificacion) }
	scope :select_promedio, -> { select("(substr(cast(calificacion as char),1,1) + substr(cast(calificacion as char),2,1) + substr(cast(calificacion as char),3,1))/3 as promedio") }
	scope :select_datos_usuario, -> { select_dibujo.select(:nombre, :apellido_paterno, :apellido_materno, :estado) } #must join direcciones
	scope :select_lugar, -> { select("(substr(cast(calificacion as char),4,1)) as lugar") }
	scope :select_ganadores, -> { select_datos_usuario.select_lugar }
	scope :select_menciones, -> { select_datos_usuario.select_promedio }
	
	scope :joins_dibujos_todos, -> { left_joins(:media, :media_metadato, :calificaciones) }
	scope :joins_con_calificacion, -> { left_joins(:media, :media_metadato).joins(:calificaciones) }
	scope :joins_con_calificacion_direccion, -> { joins_con_calificacion.joins(:direccion) }
	
	scope :where_dibujos, -> { where('medias.posicion = 1').where('media_bis_usuarios_join.posicion = 2').where(concurso_id: 1) }
	
	scope :dibujos, -> { select_dibujo.joins_dibujos_todos.where_dibujos.order('usuarios.id ASC') } # All los dibujos, por eso el left join
	scope :dibujos_finalistas, -> { select_dibujo.joins_con_calificacion.where_dibujos.order('usuarios.id ASC') } # Solo los finalistas, por eso el inner join
	scope :dibujos_desempate, -> { select_dibujo.select_promedio.joins_con_calificacion.where_dibujos.order('promedio DESC').limit(6) } # Sólo los q se tienen q desempatar
	scope :dibujos_ganadores, -> { select_ganadores.joins_con_calificacion_direccion.where_dibujos.where("calificacion not like '%0'").order('lugar ASC') } # Los elegidos por los dioses... (del dibujo :P)
	scope :dibujos_para_menciones, -> (estado) { select_menciones.joins_con_calificacion_direccion.where_dibujos.where("calificacion like '%0'").where('direcciones.estado' => estado ).order('estado', 'promedio DESC').limit(1) } # Los "gracias por participar" i.e. las menciones horroríficas (falta escoger los máximos por promedio, no se pudo hacer con sql)
	
	scope :menores_a_6, -> { where("usuarios.fecha_nacimiento > \"#{Date.new(2016,2,28)}\"") } #estos en teoria no son categoria
	scope :de_6_a_8, -> { where("usuarios.fecha_nacimiento <= \"#{Date.new(2016,2,28)}\" and usuarios.fecha_nacimiento > \"#{Date.new(2013,2,28)}\"") }
	scope :menores_a_9, -> { where("usuarios.fecha_nacimiento > \"#{Date.new(2013,2,28)}\"") } #Para fusionar ambas "categorias"

	scope :de_9_a_11, -> { where("usuarios.fecha_nacimiento <= \"#{Date.new(2013,2,28)}\" and usuarios.fecha_nacimiento > \"#{Date.new(2010,2,28)}\"") }
	
	scope :de_12_a_14, -> { where("usuarios.fecha_nacimiento <= \"#{Date.new(2010,2,28)}\" and usuarios.fecha_nacimiento > \"#{Date.new(2007,2,28)}\"") }
	
	scope :de_15_a_17, -> { where("usuarios.fecha_nacimiento <= \"#{Date.new(2007,2,28)}\" and usuarios.fecha_nacimiento > \"#{Date.new(2004,2,28)}\"") }
	scope :mayores_a_17, -> { where("usuarios.fecha_nacimiento <= \"#{Date.new(2004,2,28)}\"") } #estos en teoria no son categoria
	scope :mayores_a_14, -> { where("usuarios.fecha_nacimiento <= \"#{Date.new(2007,2,28)}\"") } #Para fusionar ambas "categorias"
	
	
	def age_in_completed_years(bd)
		# Difference in years, less one if you have not had a birthday this year.
		a = FECHA_TERMINO.year - bd.year
		a = a - 1 if (
		bd.month >  FECHA_TERMINO.month or
				(bd.month >= FECHA_TERMINO.month and bd.day > FECHA_TERMINO.day)
		)
		a
	end

	def edad
		age_in_completed_years(self.fecha_nacimiento)
	end
	
end
