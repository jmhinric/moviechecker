class DropUserMovies < ActiveRecord::Migration
  def change
    drop_table :user_movies
  end
end
