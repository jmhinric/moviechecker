class SessionController < ApplicationController

  def new
    @user = User.new
    flash[:error] = nil
  end

  def create
    user = User.find_by(email: params[:email])

    if user.nil?
      flash[:error] = "Email address blank or not found"
      render :new
    elsif user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_back_or root_path(user)
    else
      flash[:error] = "That's not the correct password"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

end