class Admin::UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_admin!
  
    def index
      @users = User.all
    end
  
    def edit
      @user = User.find(params[:id])
    end
  
    def update
        @user = User.find(params[:id])
      
        if @user == current_user
          redirect_to admin_users_path, alert: "Нельзя менять свою собственную роль."
          return
        end
      
        if @user.update(user_params)
          redirect_to admin_users_path, notice: "Роль обновлена"
        else
          render :edit, alert: "Ошибка обновления"
        end
      end
      
  
    private
  
    def authorize_admin!
      redirect_to root_path, alert: "Access denied" unless current_user.admin?
    end
  
    def user_params
      params.require(:user).permit(:role)
    end
  end
  