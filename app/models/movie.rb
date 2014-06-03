class Movie < ActiveRecord::Base
  validates :title, uniqueness: true

  def movie_poster(title)
    search_title = title.gsub(' ', '+')

    rot_tom_json = HTTParty.get "http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=#{ROTTEN_TOM}&q=#{search_title}&page_limit=1"
    rot_tom = JSON(rot_tom_json)
    
    return { poster: rot_tom["movies"][0]["posters"]["original"],
             title: rot_tom["movies"][0]["title"],
             link: rot_tom["movies"][0]["links"]["alternate"] }
  end

  def already_exists?
    Movie.find_by title: title
  end
end