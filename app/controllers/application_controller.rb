class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception
	
	protected
	
	# Limita la aplicacion a un usuario y contrasenia general
	def authenticate
		@juez = nil
		if params['calificacion']['concurso'] == '2'
			authenticate_mn
		else
			authenticate_ayv
		end
	end
	
	def authenticate_ayv
		authorized = false
		authenticate_or_request_with_http_basic do |username, password|
			Rails.application.secrets.entre_azul_y_verde.each do |k,v|
				authorized = (v[:usuario] == username && v[:password] == password)
				@juez = v if authorized
				return if authorized
			end
		end
	end
	
	def authenticate_mn
		authorized = false
		authenticate_or_request_with_http_basic do |username, password|
			Rails.application.secrets.mosaico_natura.each do |k,v|
				authorized = (v[:usuario] == username && v[:password] == password)
				@juez = v if authorized
				@juez[:tipo] = k if authorized
				return if authorized
			end
		end
	end

end

