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
  
end
