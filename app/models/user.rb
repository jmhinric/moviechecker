class User < ActiveRecord::Base
  validates :email, uniqueness: true, presence: true
  has_many :user_movies
  has_many :movies, through: :user_movies
  has_secure_password

  def already_owns? movie
    self.movies.find_by(title: movie.title).present?
  end
end
