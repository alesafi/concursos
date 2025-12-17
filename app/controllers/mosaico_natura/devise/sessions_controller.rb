class MosaicoNatura::Devise::SessionsController < ::Devise::SessionsController
  layout 'mosaico_natura'

  private

  def after_sign_in_path_for(resource)
		@registro = MosaicoNatura::UsuarioMn.where(user_id: resource.id).first

		if @registro.present?
			edit_user_mn_registration_path(@registro)
		else  # Es nuevo usuario
      new_mosaico_natura_registro_path
		end
  end

end