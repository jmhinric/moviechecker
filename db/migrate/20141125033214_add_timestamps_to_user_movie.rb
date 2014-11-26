class AddTimestampsToUserMovie < ActiveRecord::Migration
  def change
    add_column :user_movies, :created_at, :datetime, default: Time.now
    add_column :user_movies, :updated_at, :datetime, default: Time.now
  end
end
