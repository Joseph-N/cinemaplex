class MoviesController < ApplicationController
	def index
		@movies = Movie.all
		render json: { movies: @movies }
  end

  def configuration
    config = JSON.parse($redis.get "tmdb_config")
    render :json => config["images"]
  end
end
