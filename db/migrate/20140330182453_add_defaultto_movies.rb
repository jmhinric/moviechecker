class AddDefaulttoMovies < ActiveRecord::Migration
  def change
    change_column :movies, :seen, :boolean, default: false
  end
end
