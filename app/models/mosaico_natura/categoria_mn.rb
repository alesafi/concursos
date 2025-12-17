class MosaicoNatura::CategoriaMn < Categoria
	
	has_many :media, inverse_of: :media, foreign_key: :categoria_id, class_name: "MediaMn"

end
