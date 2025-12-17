class MosaicoNatura::DireccionMn < Direccion

    belongs_to :usuario, class_name: "UsuarioMn"
    validates_presence_of :calle, :numero, :colonia, :municipio, :cp, :estado
    
end
