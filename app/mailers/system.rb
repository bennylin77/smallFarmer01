# encoding: utf-8
class System < ActionMailer::Base
  default from: "smallFarmer01 小農1號 <smallFarmer01@gmail.com.tw>"
  helper ApplicationHelper  

  def sendConfirmation(user)
    @user = user
    subject = "簡訊驗證碼"
    mail( to: @user.email, subject: subject)
  end  
  
end
