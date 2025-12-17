class MediaAyv < Media
	
	#belongs_to :categoria
	belongs_to :usuario, class_name: "UsuarioAyv"
	has_one :media_metadato, inverse_of: :media, foreign_key: :media_id, class_name: "MediaMetadatoAyv", dependent: :destroy
	accepts_nested_attributes_for :media_metadato, allow_destroy: true
	
	has_one :calificacion, inverse_of: :media, foreign_key: :media_id, class_name: "CalificacionAyv"
	accepts_nested_attributes_for :calificacion, allow_destroy: true

	validates_presence_of :original_filename

	mount_uploader :original_filename, MediaUploader

	scope :where_basico, -> { where('categoria_id is null') }
	scope :por_posicion, ->(posicion) { where(posicion: posicion) }
end
