class MosaicoNatura::MosaicoNaturaController < ApplicationController
	layout 'mosaico_natura'
	
	protected
	
	def authenticate
		@juez = nil
		authenticate_mn
	end
end