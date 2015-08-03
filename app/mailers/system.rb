# encoding: utf-8
class System < ActionMailer::Base
  default from: "smallFarmer01 小農1號 <smallFarmer01@gmail.com.tw>"
  helper ApplicationHelper  

  def sendConfirmation(user)
    @user = user
    subject = "簡訊驗證碼"
    mail( to: @user.email, subject: subject)
  end  
  
  def sendNewOrder(order)
    @order = order
    subject = '【出貨通知】'+@order.product_boxing.product.name+' '+@order.quantity.to_s+'箱'
    mail( to: @order.product_boxing.product.company.user.email, subject: subject)  
  end
  
  def sendNewComment(comment)
    @comment = comment
    subject = '【留言通知】'+@comment.content
    mail( to: @comment.product.company.user.email, subject: subject)      
  end
  
end
