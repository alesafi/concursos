class MosaicoNatura::GaleriasController < MosaicoNatura::MosaicoNaturaController

  layout "mosaico_natura"

  # GET /mosaico_natura/galerias
  def index
    ganadores = MosaicoNatura::MediaMn.ganadores
    @ganadores = {}
    @menciones = {}

    ganadores.each_with_index do |ganador, index|
      if ((index + 1) % 3) == 0  # Es modulo 3, i.e. la mencion
        # Crear la categoria si aun no existe en el hash
        @menciones[ganador.nombre_categoria] = [] if !@menciones[ganador.nombre_categoria]
        @menciones[ganador.nombre_categoria] << ganador
      else
        # Crear la categoria si aun no existe en el hash
        @ganadores[ganador.nombre_categoria] = [] if !@ganadores[ganador.nombre_categoria] 
        @ganadores[ganador.nombre_categoria] << ganador
      end
    end  # end each
  end

end