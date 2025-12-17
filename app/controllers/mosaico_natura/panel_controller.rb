class MosaicoNatura::PanelController < MosaicoNatura::MosaicoNaturaController
	before_action :authenticate, only: %i[ calificacion desempate todos]
	
	def calificacion
		@fotos = {}
		MosaicoNatura::CategoriaMn.all.each do |c|
			@fotos[c.nombre_categoria] = MosaicoNatura::MediaMn.finalistas.where(categoria_id: c.id)
		end
	
	end
	
	def desempate
		@medias = {}
		if params[:categoria].present?
			categoria = params[:categoria]
			@medias[categoria] = (categoria == 'cineminuto') ?  MosaicoNatura::MediaMn.desempate_video_con_datos :  MosaicoNatura::MediaMn.desempate_foto_con_datos.where("nombre_categoria = '#{categoria}'")
		else
			MosaicoNatura::CategoriaMn.all.each do |c|
				unless c.id==8
					@medias[c.nombre_categoria] = MosaicoNatura::MediaMn.desempate_foto_con_datos.where(categoria_id: c.id).limit(10)
				else
					@medias[c.nombre_categoria] = MosaicoNatura::MediaMn.desempate_video_con_datos
				end
			end
		end
		
		respond_to do |format|
			format.html
			format.json { render json: @medias.to_json }
		end
	end
	
	def ganadores
		@medias = {}
		MosaicoNatura::CategoriaMn.all.each do |c|
				@medias[c.nombre_categoria] = MosaicoNatura::MediaMn.ganadores.where(categoria_id: c.id)
		end

		respond_to do |format|
			format.html
			format.json { render json: @medias.to_json, status: :ok}
		end
	end
	
	def todos
		@medias = {}
		if params[:categoria].present?
			categoria = params[:categoria]
			@medias[categoria] = MosaicoNatura::MediaMn.todo_de_todos.where("nombre_categoria = '#{categoria}'")
		else
			MosaicoNatura::CategoriaMn.all.each do |c|
				@medias[c.nombre_categoria] = MosaicoNatura::MediaMn.todo_de_todos.where(categoria_id: c.id)
			end
		end
		render json: @medias.to_json
		
	end
end
