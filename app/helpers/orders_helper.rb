module OrdersHelper
  def orderStatusOptions
    [['已取消', GLOBAL_VAR['ORDER_STATUS_CANCEL']],
     ['尚未確認', GLOBAL_VAR['ORDER_STATUS_UNCONFIRMED']], 
     ['處理中', GLOBAL_VAR['ORDER_STATUS_CONFIRMED']],     
     ['已通知物流', GLOBAL_VAR['ORDER_STATUS_CALLED_LOGISTICS']],     
     ['運送中', GLOBAL_VAR['ORDER_STATUS_SHIPPING']],
     ['已交付', GLOBAL_VAR['ORDER_STATUS_DELIVERED']]]
  end  
end
