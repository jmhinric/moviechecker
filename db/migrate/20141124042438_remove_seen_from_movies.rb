class RemoveSeenFromMovies < ActiveRecord::Migration
  def change
    remove_column :movies, :seen, :boolean, default: :false
  end
end
