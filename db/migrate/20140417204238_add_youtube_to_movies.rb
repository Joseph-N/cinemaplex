class AddYoutubeToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :youtube, :string
  end
end
