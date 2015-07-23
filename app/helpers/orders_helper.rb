module OrdersHelper
  def orderCompanyStatusOptions
    [['已取消', GLOBAL_VAR['ORDER_STATUS_CANCELED']],
     ['尚未通知物流', GLOBAL_VAR['ORDER_STATUS_UNCONFIRMED']], 
     ['已通知物流', GLOBAL_VAR['ORDER_STATUS_CONFIRMED']],     
     ['物流處理中', GLOBAL_VAR['ORDER_STATUS_CALLED_LOGISTICS']],     
     ['運送中', GLOBAL_VAR['ORDER_STATUS_SHIPPING']],
     ['已交付', GLOBAL_VAR['ORDER_STATUS_DELIVERED']]]
  end  
  
  def orderCustomerStatusOptions
    [['已取消', GLOBAL_VAR['ORDER_STATUS_CANCELED']],
     ['尚未處理', GLOBAL_VAR['ORDER_STATUS_UNCONFIRMED']], 
     ['農夫處理中', GLOBAL_VAR['ORDER_STATUS_CONFIRMED']],     
     ['物流處理中', GLOBAL_VAR['ORDER_STATUS_CALLED_LOGISTICS']],     
     ['運送中', GLOBAL_VAR['ORDER_STATUS_SHIPPING']],
     ['已交付', GLOBAL_VAR['ORDER_STATUS_DELIVERED']]]
  end    

  def orderBackendStatusOptions
    [['已取消', GLOBAL_VAR['ORDER_STATUS_CANCELED']],
     ['等待農夫處理', GLOBAL_VAR['ORDER_STATUS_UNCONFIRMED']], 
     ['等待小農通知物流', GLOBAL_VAR['ORDER_STATUS_CONFIRMED']],     
     ['已通知物流', GLOBAL_VAR['ORDER_STATUS_CALLED_LOGISTICS']],     
     ['運送中', GLOBAL_VAR['ORDER_STATUS_SHIPPING']],
     ['已交付', GLOBAL_VAR['ORDER_STATUS_DELIVERED']]]
  end  
  
  def orderReviewOptions
    [['超級難吃', GLOBAL_VAR['ORDER_REVIEW_UNEATABLE']],
     ['難吃', GLOBAL_VAR['ORDER_REVIEW_UNAPPEALING']], 
     ['普通', GLOBAL_VAR['ORDER_REVIEW_COMMON']],     
     ['好吃', GLOBAL_VAR['ORDER_REVIEW_TASTY']],
     ['超好吃', GLOBAL_VAR['ORDER_REVIEW_DELICIOUS']]]     
  end     
end
