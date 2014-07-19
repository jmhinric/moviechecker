class MoviesController < ApplicationController

  before_action :load_movie, only: [:update, :destroy]

  def index
    @movies = Movie.all.order(updated_at: :asc)

    respond_to do |format|
      format.html { render :index }
      format.json { render json: @movies }
    end
  end

  def create
    @movie = Movie.new(
      title: params["title"],
      poster: params["poster"],
      link: params["link"]
    )

    if @movie.save
      render json: @movie
    elsif @movie.already_exists?
      render json: { errors: "Movie already added" }
    else
      render status: 400, nothing: true
    end

  end

  def update
    if @movie.update(movie_params)
      render json: @movie
    else
      render status: 400, nothing: true
    end
  end

  def destroy
    if @movie.destroy
      render json: {}
    else
      render status: 400, nothing: true
    end
  end

  def api
    @movie = Movie.new
    @movie_info = @movie.movie_poster(params['title'])

    # @movie.poster = @movie_info[:poster]
    # @movie.title = @movie_info[:title]
    # @movie.link = @movie_info[:link]

    render json: { title: @movie_info[:title], poster: @movie_info[:poster], link: @movie_info[:link] }
  end

  private

  def movie_params
    params.require(:movie).permit(:title, :seen)
  end

  def load_movie
    @movie = Movie.find(params[:id])
  end


end