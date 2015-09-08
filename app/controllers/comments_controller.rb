class CommentsController < ApplicationController
  before_filter :authenticate_user!, except: [:show] 
  
  before_action only: [:delete] { |c| c.CommentCheckUser(params[:id])}              
  before_action :set_comment, only: [:delete, :postSub]
  before_action only: [:deleteSub] { |c| c.SubCommentCheckUser(params[:id])}                
  before_action :set_sub_comment, only: [:deleteSub]  
  before_action :set_product, only: [:post, :show]
  

  def post
    comment = Comment.new()
    comment.content = params[:content]
    comment.user = current_user 
    comment.product = @product
    comment.save!
    System.sendNewComment(comment).deliver      
    notify( @product.company.user, { category: GLOBAL_VAR['NOTIFICATION_COMMENT'], 
                                     sub_category: GLOBAL_VAR['NOTIFICATION_SUB_NEW_COMMENT'], 
                                     comment_id: comment.id})   
    if request.xhr?
      render json: {success: true, message: '張貼成功'}   
    else
      redirect_to @product       
    end            
  end

  def show       
    comments = Array.new
    @product.comments.order('id desc').each do |c|
      comment = { id: c.id, content: c.content, user_id: c.user.id, created_at: c.created_at.strftime("%Y-%m-%d %H:%M:%S"),
                  user_last_name: c.user.last_name, user_avatar_url: c.user.avatar.url, email: c.user.email.gsub(/..@.*$/, '')}
      sub_comments = Array.new            
      c.sub_comments.each do |s_c|
        sub_comments << {
          id: s_c.id,
          content: s_c.content, 
          user_id: s_c.user.id, 
          user_last_name: s_c.user.last_name, 
          user_avatar_url: s_c.user.avatar.url, 
          created_at: s_c.created_at, 
          email: s_c.user.email.gsub(/..@.*$/, '')                  
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
    @comment.destroy
    render json: {success: true, message: '刪除成功'} 
  end
  
  def postSub
    sub_comment = SubComment.new()
    sub_comment.content = params[:content]
    sub_comment.user = current_user
    sub_comment.comment = @comment
    sub_comment.save!    
    if sub_comment.comment.product.company.user == current_user
      notficationRead( { category: GLOBAL_VAR['NOTIFICATION_COMMENT'], 
                         sub_category: GLOBAL_VAR['NOTIFICATION_SUB_NEW_COMMENT'], 
                         comment_id: sub_comment.comment.id})
    end
    
=begin    
    notify( sub_comment.comment.user, { category: GLOBAL_VAR['NOTIFICATION_COMMENT'], 
                                        sub_category: GLOBAL_VAR['NOTIFICATION_SUB_NEW_SUB_COMMENT'], 
                                        sub_comment_id: sub_comment.id})     
=end    
    render json: {success: true, message: '張貼成功'}     
  end

  def deleteSub
    @sub_comment.destroy
    render json: {success: true, message: '刪除成功'} 
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
