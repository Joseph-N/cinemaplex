class MoviesController < ApplicationController
	def index
		@movies = Movie.all
		render json: @movies, :callback => params['callback']
  	end

  	def show
  		@movie = Movie.find(params[:id])
  		render json: @movie, :callback => params['callback']
  	end

	def configuration
		config = JSON.parse($redis.get "tmdb_config")
		render :json => config["images"], :callback => params['callback']
	end
end
