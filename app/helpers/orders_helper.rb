module OrdersHelper
  def orderCompanyStatusOptions
    [['已取消', GLOBAL_VAR['ORDER_STATUS_CANCEL']],
     ['尚未通知物流', GLOBAL_VAR['ORDER_STATUS_UNCONFIRMED']], 
     ['已通知物流', GLOBAL_VAR['ORDER_STATUS_CONFIRMED']],     
     ['處理中', GLOBAL_VAR['ORDER_STATUS_CALLED_LOGISTICS']],     
     ['運送中', GLOBAL_VAR['ORDER_STATUS_SHIPPING']],
     ['已交付', GLOBAL_VAR['ORDER_STATUS_DELIVERED']]]
  end  
  
  def orderCustomerStatusOptions
    [['已取消', GLOBAL_VAR['ORDER_STATUS_CANCEL']],
     ['尚未處理', GLOBAL_VAR['ORDER_STATUS_UNCONFIRMED']], 
     ['處理中', GLOBAL_VAR['ORDER_STATUS_CONFIRMED']],     
     ['處理中', GLOBAL_VAR['ORDER_STATUS_CALLED_LOGISTICS']],     
     ['運送中', GLOBAL_VAR['ORDER_STATUS_SHIPPING']],
     ['已交付', GLOBAL_VAR['ORDER_STATUS_DELIVERED']]]
  end    
end
