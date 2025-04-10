class ProductsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_product, only: %i[show edit update destroy]
  before_action :authorize_user!, only: %i[edit update destroy]

  def index
    @categories = Product.distinct.pluck(:category)
    @products = Product.all

    if params[:q].present? && params[:category].present?
      @products = @products.where("name LIKE :query AND category = :category", query: "%#{params[:q]}%", category: params[:category])
    elsif params[:q].present?
      @products = @products.where("name LIKE ?", "%#{params[:q]}%")
    elsif params[:category].present?
      @products = @products.where(category: params[:category])
    end
  end

  def show; end

  def new
    @product = current_user.products.build
  end

  def edit; end

  def create
    @product = current_user.products.build(product_params)

    if @product.save
      redirect_to @product, notice: "Product was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      redirect_to @product, notice: "Product was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy!
    redirect_to products_path, status: :see_other, notice: "Product was successfully destroyed."
  end

  private

  def set_product
    @product = Product.find(params[:id])
    @product.comments = @product.comments.includes(:user)  # Ensure comments are loaded along with the product
  end
  

  def authorize_user!
    return if current_user.admin? || current_user.moderator?
    return if @product.user == current_user

    redirect_to products_path, alert: "Access denied."
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :category)
  end
  
end
