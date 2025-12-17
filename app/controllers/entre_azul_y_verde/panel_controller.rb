class EntreAzulYVerde::PanelController < EntreAzulYVerde::EntreAzulYVerdeController
  before_action :authenticate, only: %i[ precalificacion calificacion desempate]

	def precalificacion
		@dibujos = {}
		@dibujos[:de_6_a_8] = UsuarioAyv.dibujos.de_6_a_8
		@dibujos[:de_9_a_11] = UsuarioAyv.dibujos.de_9_a_11
		@dibujos[:de_12_a_14] = UsuarioAyv.dibujos.de_12_a_14
		@dibujos[:de_15_a_17] = UsuarioAyv.dibujos.de_15_a_17
		@dibujos[:menores_a_6] = UsuarioAyv.dibujos.menores_a_6
		@dibujos[:mayores_a_17] = UsuarioAyv.dibujos.mayores_a_17
	end

	def calificacion
		@dibujos = {}
		@dibujos[:menores_a_9] = UsuarioAyv.dibujos_finalistas.menores_a_9
		@dibujos[:de_9_a_11] = UsuarioAyv.dibujos_finalistas.de_9_a_11
		@dibujos[:de_12_a_14] = UsuarioAyv.dibujos_finalistas.de_12_a_14
		@dibujos[:mayores_a_14] = UsuarioAyv.dibujos_finalistas.mayores_a_14
	end
	
  def desempate
	  @dibujos = {}
	  @dibujos[:menores_a_9] = UsuarioAyv.dibujos_desempate.menores_a_9
	  @dibujos[:de_9_a_11] = UsuarioAyv.dibujos_desempate.de_9_a_11
	  @dibujos[:de_12_a_14] = UsuarioAyv.dibujos_desempate.de_12_a_14
	  @dibujos[:mayores_a_14] = UsuarioAyv.dibujos_desempate.mayores_a_14
  end
end
