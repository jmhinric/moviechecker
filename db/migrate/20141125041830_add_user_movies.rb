class AddUserMovies < ActiveRecord::Migration
  def change
    create_table :user_movies do |t|
      t.references :user
      t.references :movie
      t.boolean :seen, default: :false
      t.timestamps
    end
  end
end
