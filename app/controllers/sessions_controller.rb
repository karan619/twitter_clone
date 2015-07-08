class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
			log_in(user)
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      flash[:success] = "Welcom #{user.name}"
      redirect_back_or(user)
    else
      flash[:danger] = "Access Denied"
      render 'new'
    end
  end

  def destroy
      log_out if logged_in?
      flash[:success] = "Logged Out"
      redirect_to root_url
    end
end
