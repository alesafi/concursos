class EntreAzulYVerde::GaleriasController < EntreAzulYVerde::EntreAzulYVerdeController

  def index
    @ganadores = {}
    @ganadores[:de_6_a_8] = UsuarioAyv.dibujos_ganadores.menores_a_9
    @ganadores[:de_9_a_11] = UsuarioAyv.dibujos_ganadores.de_9_a_11
    @ganadores[:de_12_a_14] = UsuarioAyv.dibujos_ganadores.de_12_a_14
    @ganadores[:de_15_a_17] = UsuarioAyv.dibujos_ganadores.mayores_a_14
	  
    @menciones = {}
    Direccion::ESTADOS.each do |x|
	    mencion = UsuarioAyv.dibujos_para_menciones(x[1])
	    next unless mencion.present?
	    @menciones[x[0]] = mencion
    end
	  
  end
end
