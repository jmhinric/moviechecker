class UsersController < ApplicationController

  before_action :load_user, only: [:show, :edit, :update, :destroy]

  before_action :authenticate, :authorize, only: [:edit, :update, :destroy]

  def show
  end

  def new
     @user = User.new
  end 

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path(@user)
    else
      render :new
    end
  end

  def edit
  end

  def update
    #make the change to the user suggested by the form...
    if @user.update(user_params)
      flash.discard(:notice)
      redirect_to user_path(@user)
    else
      @user = load_user
      flash[:notice] = "Sorry, invalid information..."
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:notice] = "Profile successfully deleted!"
    redirect_to root_path
  end

  
  private

  def load_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :created_at, :updated_at)
  end

end