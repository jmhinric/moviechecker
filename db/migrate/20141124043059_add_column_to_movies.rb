class AddColumnToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :seen, :boolean, default: :false
  end
end
