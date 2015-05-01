class CommentsController < ApplicationController
  before_action :set_comment, only: [:edit, :update, :destroy]
  before_action :set_product, only: [:post, :show]

  respond_to :html

  def post
    comment = Comment.new()
    comment.content = params[:content]
    comment.user = current_user
    comment.product = @product
    comment.save!
    render json: {alert_class: 'success', message: '張貼成功'}           
  end

  def show       
    comments = Array.new
    @product.comments.each do |c|
      comment = { id: c.id, content: c.content, user_id: c.user.id, created_at: c.created_at.strftime("%Y-%m-%d %H:%M:%S"),
                  user_last_name: c.user.last_name, user_avatar_url: c.user.avatar.url}
      sub_comments = Array.new            
      c.sub_comments.each do |s_c|
        sub_comments << {
          id: s_c.id,
          content: s_c.content, 
          user_id: s_c.user.id, 
          user_last_name: s_c.user.last_name, 
          user_avatar_url: s_c.user.avatar.url, 
          created_at: s_c.created_at                  
        }            
      end
      comments << 
      {
        comment: comment,
        sub_comments: sub_comments 
      }     
      
    end
    render json: comments.to_json 
  end
  
  
  
  

  def new
    @comment = Comment.new
    respond_with(@comment)
  end

  def edit
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.save
    respond_with(@comment)
  end

  def update
    @comment.update(comment_params)
    respond_with(@comment)
  end

  def destroy
    @comment.destroy
    respond_with(@comment)
  end

  private
    def set_comment
      @comment = Comment.find(params[:id])
    end
    
    def set_product
      @product = Product.find(params[:id])
    end
    
    def comment_params
      params.require(:comment).permit(:user_id, :product_id, :content)
    end
end
