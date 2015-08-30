# encoding: utf-8
class System < ActionMailer::Base
  default from: "smallFarmer01 小農1號 <no-reply@smallfarmer01.com>"
  helper ApplicationHelper  
  helper ProductsHelper   
  helper OrdersHelper   
=begin
  def sendConfirmation(user)
    @user = user
    subject = "簡訊驗證碼"
    mail( to: @user.email, subject: subject)
  end  
=end  
  def sendNewOrder(order)
    @order = order
    subject = '【出貨通知】'+@order.product_boxing.product.name+' '+@order.quantity.to_s+'箱'
    mail( to: @order.product_boxing.product.company.user.email, subject: subject)  
  end
  
  def sendNewComment(comment)
    @comment = comment
    subject = '【留言通知】'+@comment.content
    mail( to: @comment.product.company.user.email, subject: subject)
    render layout: 'user_email'      
  end
  
  def sendPurchaseCompleted(invoice)
    @invoice = invoice
    subject = '付款成功通知'
    mail( to: @invoice.user.email, subject: subject) do |format|
      format.html { render layout: 'user_email' }
      format.text
    end            
  end

  def sendReviewNotification(invoice)
    @invoice = invoice
    @discount = 0 
    @invoice.invoice_coupon_lists.each do |i_c_l|
      @discount = @discount + i_c_l.amount
    end      
    subject = '您的訂單已交付完畢, 立刻評價獲得 '+((@invoice.amount-@discount)*0.04).round.to_s+'元 回饋金'        
    mail( to: @invoice.user.email, subject: subject)      
  end
  
end
