module NotificationsHelper

  def categoryOptions
    [['留言', GLOBAL_VAR['NOTIFICATION_COMMENT']],
     ['訂單', GLOBAL_VAR['NOTIFICATION_PRODUCT']], 
     ['系統', GLOBAL_VAR['NOTIFICATION_SYSTEM']],
     ['評價', GLOBAL_VAR['NOTIFICATION_PROMOTION']]]
  end   
  
end
