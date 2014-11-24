class MoviesController < ApplicationController

  before_action :load_movie, only: [:update, :destroy]
  before_action :load_user
  before_action :authenticate, :authorize

  def index
    @movies = Movie.all.order(updated_at: :asc)
    # @movies = @current_user.movies.all.order(update_at: :asc)

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
    @movie_info = @movie.movie_poster(params['title'], 5)

    render json: { movies: @movie_info }
  end

  private

  def movie_params
    params.require(:movie).permit(:title, :seen)
  end

  def load_movie
    @movie = Movie.find(params[:id])
  end

  def load_user
    @user = current_user
  end


end