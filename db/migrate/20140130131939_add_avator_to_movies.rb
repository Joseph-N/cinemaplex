class AddAvatorToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :avator, :string
  end
end
