class CommentsController < ApplicationController

  before_filter :authenticate_user!, except: [:show] 
  
  before_action :set_comment, only: [:delete, :postSub]
  before_action :set_sub_comment, only: [:deleteSub]  
  before_action :set_product, only: [:post, :show]
  

  def post
    if request.xhr?
      comment = Comment.new()
      comment.content = params[:content]
      comment.user = current_user
      comment.product = @product
      comment.save!
      render json: {success: true, message: '張貼成功'}   
    else
      comment = Comment.new()
      comment.content = params[:content]
      comment.user = current_user
      comment.product = @product
      comment.save!
      redirect_to @product       
    end            
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
  
  def delete
    if @comment.user == current_user
      @comment.destroy
      render json: {success: true, message: '刪除成功'} 
    end       
  end
  
  def postSub
    sub_comment = SubComment.new()
    sub_comment.content = params[:content]
    sub_comment.user = current_user
    sub_comment.comment = @comment
    sub_comment.save!
    render json: {success: true, message: '張貼成功'}     
  end

  def deleteSub
    if @sub_comment.user == current_user
      @sub_comment.destroy
      render json: {success: true, message: '刪除成功'} 
    end       
  end

  private
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def set_sub_comment
      @sub_comment = SubComment.find(params[:id])
    end
    
    def set_product
      @product = Product.find(params[:id])
    end
    
    def comment_params
      params.require(:comment).permit(:user_id, :product_id, :content)
    end
end
