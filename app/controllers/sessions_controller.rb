class SessionsController < ApplicationController
  def login
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      # User provided valid auth creds
      session[:id] = user.id
      redirect_to root_path, notice: "Welcome back #{user.first_name}"
    else
      # User provided invalid creds
      flash[:error] = 'Invalid credentials'
      render :login
    end
  end

  def destroy
    if user = current_user
      session.delete(:id)
      redirect_to root_path, notice: "#{user.email} has been logged out"
    end
  end
end
