class MoviesController < ApplicationController

  before_action :load_movie, only: [:update, :destroy]

  def index
    @movies = Movie.all.order(:id)

    respond_to do |format|
      format.html { render :index }
      format.json { render json: @movies }
    end
  end

  def create
    @movie = Movie.new(movie_params)
    @movie.poster = @movie.movie_poster(@movie.title)

    if @movie.save
      render json: @movie
    else
      render status: 400, nothing: true
    end
  end

  def update
    if params[:title]
      @movie.poster = @movie.movie_poster(params[:title])
    end

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


  private

  def movie_params
    params.require(:movie).permit(:title, :seen)
  end

  def load_movie
    @movie = Movie.find(params[:id])
  end

end