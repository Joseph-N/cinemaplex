class MoviesController < ApplicationController
	def index
		@movies = Movie.all
		render json: @movies
  	end

  	def show
  		@movie = Movie.find(params[:id])
  		render json: @movie
  	end

	def configuration
		config = JSON.parse($redis.get "tmdb_config")
		render :json => config["images"]
	end
end
