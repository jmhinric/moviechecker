class AddLinkToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :link, :text
  end
end
