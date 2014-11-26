class MoviesController < ApplicationController

  before_action :load_movie, only: [:update, :destroy]
  before_action :load_user
  before_action :authenticate, :authorize

  def index
    @movies = @user.movies.all
    # @user_movies = UserMovie.where(user_id: @user.id)
    @movies.map do |movie|
      # user_movie = @user_movies.find_by(movie_id: m.id)
      movie.seen = UserMovie.get_user_movie(@user, movie).seen
      movie
    end
    @movies.sort_by! { |m| UserMovie.get_user_movie(@user, m).updated_at } if @movies.present?

    respond_to do |format|
      format.html { render :index }
      format.json { render json: @movies }
    end
  end

  def create
    existing_movie = Movie.find_by(title: params["title"])

    if existing_movie
      if @user.already_owns? existing_movie
        render json: { errors: "Movie already added" }
      else
        if @user.movies << existing_movie
          render json: existing_movie
        else
          render status: 400, nothing: true
        end
      end
    else
      new_movie = Movie.new(
        title: params["title"],
        poster: params["poster"],
        link: params["link"]
      )
      if new_movie.save
        @user.movies << new_movie
        render json: new_movie
      else
        render status: 400, nothing: true
      end
    end
  end

  def update
    user_movie = UserMovie.get_user_movie(@user, @movie)
    if user_movie.toggle!(:seen)
      # update({ seen: params[:seen] })
      # user_movie.save
      @movie.seen = user_movie.seen
      render json: @movie
    else
      render status: 400, nothing: true
    end
  end

  def destroy
    if @user.movies.delete @movie
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