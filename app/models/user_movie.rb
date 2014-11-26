class UserMovie < ActiveRecord::Base
  belongs_to :user
  belongs_to :movie
  # validates :seen, presence: true

  def self.get_user_movie(user, movie)
    self.where({ 
      user_id: user.id,
      movie_id: movie.id }).first
  end
end