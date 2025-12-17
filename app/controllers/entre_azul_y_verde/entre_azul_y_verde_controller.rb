class EntreAzulYVerde::EntreAzulYVerdeController < ApplicationController
	layout 'entre_azul_y_verde'
	
	protected
	
	def authenticate
		@juez = nil
		authenticate_ayv
	end
end