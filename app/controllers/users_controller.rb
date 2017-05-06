class UsersController < ApplicationController
  
  def show
    if current_user == nil
      flash[:alert] = 'Please log in first.'
      redirect_to new_user_session_url
    elsif current_user.admin?
      @user = User.friendly.find(params[:id])
    else
      @user = current_user
    end
  end
  
  def list
    if current_user == nil || !current_user.admin?
      redirect_to root_url
    else
      @users = User.all
    end
  end
  
end
