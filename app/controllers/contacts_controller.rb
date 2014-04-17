class ContactsController  < ApplicationController
	def index
		@cinema = Cinema.find(params[:cinema_id])
		@contacts = @cinema.contacts
		render json: @contacts
	end
end