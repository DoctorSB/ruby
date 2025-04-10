class Admin::CategoriesController < ApplicationController
    before_action :authenticate_user!
    before_action :check_admin
    before_action :set_category, only: [:edit, :update, :destroy]
  
    def index
      @categories = Category.all
      @category = Category.new
    end
  
    def create
      @category = Category.new(category_params)
      if @category.save
        redirect_to admin_categories_path, notice: 'Категория успешно создана'
      else
        @categories = Category.all
        render :index
      end
    end
  
    def edit
    end
  
    def update
      if @category.update(category_params)
        redirect_to admin_categories_path, notice: 'Категория обновлена'
      else
        render :edit
      end
    end
  
    def destroy
      @category.destroy
      redirect_to admin_categories_path, notice: 'Категория удалена'
    end
  
    private
  
    def set_category
      @category = Category.find(params[:id])
    end
  
    def category_params
      params.require(:category).permit(:name)
    end
  
    def check_admin
      redirect_to root_path, alert: 'Доступ запрещен' unless current_user.admin?
    end
  end