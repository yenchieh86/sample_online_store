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
    if current_user && current_user.role == 'admin'
      @users = User.all
    else
      redirect_to root_url
    end
  end
  
  def erase
    if current_user != nil && current_user.admin?
      @user = User.friendly.find(params[:id])
      if @user.destroy
        flash[:success] = 'You just delete an user.'
        redirect_to user_list_url
      else
        flash.now[:alert] = @user.errors.full_messages
        render :list
      end
    else
      redirect_to root_url
    end
  end
  
end
