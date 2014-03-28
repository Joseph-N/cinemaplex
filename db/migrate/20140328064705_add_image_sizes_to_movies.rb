class AddImageSizesToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :poster, :string
    add_column :movies, :backdrop, :string
    remove_column :movies, :avator
  end
end
