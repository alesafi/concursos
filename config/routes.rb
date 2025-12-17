Rails.application.routes.draw do
  #devise_for :users
	#devise_for :user_ayv, :controllers => {:confirmations => "entre_azul_y_verde/devise/confirmations", :passwords => "entre_azul_y_verde/devise/passwords", :registrations => "entre_azul_y_verde/devise/registrations", :unlocks => "entre_azul_y_verde/devise/unlocks", :sessions => "entre_azul_y_verde/devise/sessions"}
  #devise_for :user_mn, :controllers => {:confirmations => "mosaico_natura/devise/confirmations", :passwords => "mosaico_natura/devise/passwords", :registrations => "mosaico_natura/devise/registrations", :unlocks => "mosaico_natura/devise/unlocks", :sessions => "mosaico_natura/devise/sessions"}
	
	resources :cat_concursos
	resources :media_metadatos
	resources :usuario_metadatos
	resources :cat_metadatos
	resources :direcciones
	resources :categorias
	resources :usuarios
	resources :medias
	resources :calificaciones
	# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	
	
	if Rails.env.development?
		namespace 'entre_azul_y_verde' do
			root 'inicio#index'
			get 'quees' => 'inicio#index'
			get 'categorias' => 'inicio#index'
			get 'medios' => 'inicio#index'
			
			get 'bases' => 'inicio#bases'
			get '/galerias/index'
			get '/galerias/' => 'galerias#index'
			
      resources :panel do
				collection do
					get :precalificacion
					get :calificacion
          get :desempate
        end
      end
    end
		
		namespace 'mosaico_natura' do
			root 'inicio#index'
			get 'quees' => 'inicio#index'
			get 'categorias' => 'inicio#index'
			get 'medios' => 'inicio#index'
			get 'bases' => 'inicio#bases'
			get 'terminos_condiciones' => 'inicio#terminos_condiciones'
			get '/galerias/index'
			get '/galerias/' => 'galerias#index'
			resources :panel do
				collection do
					get :calificacion
					get :desempate
					get :ganadores
					get :todos
				end
			end
    end

	else
		constraints(lambda { |request| ['entreazulyverde.mx','www.entreazulyverde.mx'].include?(request.host) }) do
			root 'entre_azul_y_verde/inicio#index'
			namespace 'entre_azul_y_verde' do
				root 'inicio#index'
				get 'quees' => 'inicio#index'
				get 'categorias' => 'inicio#index'
				get 'medios' => 'inicio#index'
				
				get 'bases' => 'inicio#bases'
				get '/galerias/index'
				get '/galerias/' => 'galerias#index'
				resources :panel do
					collection do
						get :precalificacion
						get :calificacion
						get :desempate
					end
				end
			end
		end
		
		constraints(lambda { |request| ['mosaiconatura.net','www.mosaiconatura.net'].include?(request.host) }) do
			root 'mosaico_natura/inicio#index'
			namespace 'mosaico_natura' do
				root 'inicio#index'
				get 'quees' => 'inicio#index'
				get 'categorias' => 'inicio#index'
				get 'medios' => 'inicio#index'
				get 'bases' => 'inicio#bases'
				get 'terminos_condiciones' => 'inicio#terminos_condiciones'
				get '/galerias/index'
				get '/galerias/' => 'galerias#index'
				resources :galerias
				resources :panel do
					collection do
						get :calificacion
						get :desempate
						get :ganadores
						get :todos
					end
				end
			end
		end
	end



end
