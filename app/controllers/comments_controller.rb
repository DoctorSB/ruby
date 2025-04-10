class CommentsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_product
    before_action :set_comment, only: [:destroy]
    before_action :check_ownership!, only: [:destroy] # Добавляем проверку прав
  
    def create
      @comment = @product.comments.build(comment_params)
      @comment.user = current_user
  
      if @comment.save
        redirect_to @product, notice: "Комментарий добавлен!"
      else
        # Передаем ошибки через flash для отображения
        redirect_to @product, alert: "Ошибка: #{@comment.errors.full_messages.join(', ')}"
      end
    end
  
    def destroy
        if @comment.nil?
          Rails.logger.error "Comment not found: #{params[:id]}"
        else
          @comment.destroy
          redirect_to @product, notice: "Комментарий удален."
        end
      end
      
  
    private
  
    def set_product
      @product = Product.find(params[:product_id])
    end
  
    def set_comment
      @comment = @product.comments.find(params[:id])
    end
  
    def check_ownership!
      unless @comment.user == current_user || current_user.admin? || current_user.moderator?
        redirect_to @product, alert: "Недостаточно прав для этого действия."
      end
    end
  
    def comment_params
      params.require(:comment).permit(:content)
    end
  end