class CalificacionesController < ApplicationController
	before_action :set_calificacion, only: %i[ update destroy ]
	before_action :authenticate, only: %i[ create update destroy ]
	
	# POST /calificaciones or /calificaciones.json
	def create
		@calificacion = Calificacion.new(calificacion_params)
		
		respond_to do |format|
			if @calificacion.save
				#format.html { redirect_to @calificacion, notice: "Calificacion was successfully created." }
				format.json { render json: {status: :created, location: @calificacion } }
			else
				#format.html { render :new, status: :unprocessable_entity }
				format.json { render json: @calificacion.errors, status: :unprocessable_entity }
			end
		end
	end
	
	# PATCH/PUT /calificaciones/1 or /calificaciones/1.json
	def update
		unless(@juez.nil?)
			#Jalo la calificacion entera a tres digitos en la base
			cal_global = @calificacion.calificacion.to_s
			#cambio solo lacalificacion determinada por la posicion del juez
			cal_global[@juez[:posicion]] = calificacion_params[:calificacion]
			#Como era string, pues la calificacion ya cambada a 3 digitos la sustituyo en los params para q el modelo la reciba peladita
			params[:calificacion][:calificacion] = cal_global
		end
		
		respond_to do |format|
			if @calificacion.update(calificacion_params)
				#format.html { redirect_to @calificacion, notice: "Calificacion was successfully updated." }
				format.json { render json: {status: :updated, location: @calificacion } }
			else
				#format.html { render :edit, status: :unprocessable_entity }
				format.json { render json: @calificacion.errors, status: :unprocessable_entity }
			end
		end
	end
	
	# DELETE /calificaciones/1 or /calificaciones/1.json
	def destroy
		@calificacion.destroy
		respond_to do |format|
			format.html { redirect_to calificaciones_url, notice: "Calificacion was successfully destroyed." }
			format.json { head :no_content }
		end
	end
	
	private
	# Use callbacks to share common setup or constraints between actions.
	def set_calificacion
		id = params[:id]
		if params['calificacion']['concurso'] == '2'
			@calificacion = Calificacion.find_by_media_id(id)
		else
			@calificacion = Calificacion.find_by_usuario_id(id)
		end
	end
	
	# Only allow a list of trusted parameters through.
	def calificacion_params
		params.fetch(:calificacion, {}).permit(:usuario_id, :medias_id, :calificacion )
	end
end
