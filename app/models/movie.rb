class Movie < ActiveRecord::Base
  def movie_poster(title)
    search_title = title.gsub(' ', '+')

    omdb_json = HTTParty.get "http://www.omdbapi.com/?t=#{search_title}"
    omdb = JSON(omdb_json)
    return omdb["Poster"]
  end
end