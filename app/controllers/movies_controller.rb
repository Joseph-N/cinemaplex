class MoviesController < ApplicationController
	def index
		@movies = Movie.all
		render json: { movies: @movies } 
	end
end
