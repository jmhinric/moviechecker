class CreateUserMoviesTable < ActiveRecord::Migration
  def change
    create_table :user_movies do |t|
      t.references :user
      t.references :movie
    end
  end
end
