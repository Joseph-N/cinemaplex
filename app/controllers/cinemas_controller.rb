class CinemasController < ApplicationController
	def index
		@movie = Movie.find(params[:movie_id])
		@cinemas = @movie.cinemas
		render json: @cinemas, :callback => params['callback']
	end
end
