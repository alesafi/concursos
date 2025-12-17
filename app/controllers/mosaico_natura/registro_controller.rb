class MosaicoNatura::RegistroController < MosaicoNatura::MosaicoNaturaController
	before_action :set_registro, only: %i[ show edit update destroy ]
	before_action :set_categorias, only: %i[ edit update ]
	before_action :authenticate_user_mn!
	
	# GET /registro/new
	def new
		@registro = MosaicoNatura::UsuarioMn.where(user_id: current_user_mn.id).first

		if @registro.present?
			redirect_to edit_mosaico_natura_registro_path(@registro)
		else  # Es nuevo usuario
			@form_params = { url: '/mosaico_natura/registro', method: 'post' }
			@registro = MosaicoNatura::UsuarioMn.new
			@registro.build_direccion
			#@registro.media.build
			#@registro.media.build(posicion: 2).build_media_metadato  # Solo la foto final tiene asociado los metadatos
		end
	end
	
	# GET /registro/1/edit
	def edit
		@form_params = { url: mosaico_natura_registro_path(@registro), method: 'put' }
	end
	
	# POST /registro or /registro.json
	def create
		@registro = MosaicoNatura::UsuarioMn.new(registro_params)

		# Asigna le concurso
		concurso = CatConcurso.where(nombre_concurso: UsuarioMn::CONCURSO).first
		@registro.concurso_id = concurso.id
		
		respond_to do |format|
			if @registro.save
				format.html { redirect_to edit_mosaico_natura_registro_path(@registro), notice: "Tu registro fue creado exitosamente." }
				format.json { render :show, status: :created, location: @registro }
			else
				@form_params = { url: '/mosaico_natura/registro', method: 'post' }
				format.html { render :new, locals: { notice: "Hubo un problema al guardar tus datos. Verifica que todos los campos esten completos"} }
				format.json { render json: @registro.errors, status: :unprocessable_entity }
			end
		end
	end
	
	# PATCH/PUT /registro/1 or /registro/1.json
	def update
		respond_to do |format|
			if @registro.update(registro_params)
				@form_params = { url: mosaico_natura_registro_path(@registro), method: 'put' }
				format.html { redirect_to edit_mosaico_natura_registro_path(@registro), notice: "Tu registro fue actualizado exitosamente." }
				format.json { render :show, status: :ok, location: @registro }
			else
				@form_params = { url: mosaico_natura_registro_path(@registro), method: 'put' }
				format.html { redirect_to edit_mosaico_natura_registro_path(@registro),  notice: "Hubo un problema al guardar tus datos. Verifica haber llenado todos los campos"}
				format.json { render json: @registro.errors, status: :unprocessable_entity }
			end
		end
	end

	
	private
	# Use callbacks to share common setup or constraints between actions.
	def set_registro
		@registro = MosaicoNatura::UsuarioMn.find(params[:id])
	end
	
	def set_categorias
		if @registro.present?
			if @registro.fecha_nacimiento < MosaicoNatura::UsuarioMn::FECHA_NAC_MIN_ADULTOS
				@categorias = Categoria.where(cat_concurso_id: 2).where.not(nombre_categoria: ["tema_libre"]).map{|c|[c.nombre_categoria, c.id]}
			else
				@categorias = Categoria.where(cat_concurso_id: 2).where(nombre_categoria: ["tema_libre"]).map{|c|[c.nombre_categoria, c.id]}
			end
		end
	end
	
	# Only allow a list of trusted parameters through.
	def registro_params
			params.require(:usuario_mn).permit(:nombre, :apellido_paterno, :apellido_materno, :fecha_nacimiento, :lugar_nacimiento, :medio, :otro_medio, :user_id,
			                                    direccion_attributes: [:id, :calle, :numero, :interior, :colonia, :municipio, :cp, :estado, :usuario_id, :_destroy],
			                                    media_attributes: [:id, :original_filename, :posicion, :filename, :titulo, :fecha_subida, :ruta, :size, :usuario_id, :categoria_id, :_destroy,
			                                                       media_metadato_attributes: [:id, :titulo, :descripcion, :marca, :otra_marca, :localidad, :media_id, :destroy]],
			)
	end
end

