class Movie < ActiveRecord::Base
  validates :title, uniqueness: true

  def movie_poster(title, num)
    search_title = title.gsub(' ', '+')

    rot_tom_json = HTTParty.get "http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=#{ROTTEN_TOM}&q=#{search_title}&page_limit=#{num}"
    rot_tom = JSON(rot_tom_json)
    
    return json_response(rot_tom, num);
  end

  def json_response(rot_tom, num)
    response = []
    for i in (0...num) do
      response.push(
        { poster: rot_tom["movies"][i]["posters"]["original"].gsub("tmb.jpg", "ori.jpg"),
        title: rot_tom["movies"][i]["title"],
        link: rot_tom["movies"][i]["links"]["alternate"] }
      ) 
    end
    return response
  end

  def already_exists?
    Movie.find_by title: title
  end
end