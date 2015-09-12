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
     ['等待物流載貨', GLOBAL_VAR['ORDER_STATUS_CONFIRMED']],     
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
    [['不好吃', GLOBAL_VAR['ORDER_REVIEW_UNEATABLE']],
     ['不太好吃', GLOBAL_VAR['ORDER_REVIEW_UNAPPEALING']], 
     ['普通', GLOBAL_VAR['ORDER_REVIEW_COMMON']],     
     ['好吃', GLOBAL_VAR['ORDER_REVIEW_TASTY']],
     ['超好吃', GLOBAL_VAR['ORDER_REVIEW_DELICIOUS']]]     
  end 
  
  def orderShipmentReviewOptions
    [['慢', GLOBAL_VAR['ORDER_SHIPMENT_REVIEW_SLOW']],
     ['普通', GLOBAL_VAR['ORDER_SHIPMENT_REVIEW_COMMON']], 
     ['快', GLOBAL_VAR['ORDER_SHIPMENT_REVIEW_FAST']]]     
  end   
  
  def tCatStatusOptions
    [['--', 0],
     ['已集貨', 1], 
     ['不在家', 2],     
     ['順利送達', 3],     
     ['調查處理中', 4],
     ['調查處理中', 5],
     ['配送中', 6],
     ['調查處理中', 7],
     ['公司行號休息', 8],
     ['地址不明(調查處理中)', 9],                
     ['搬家(調查處理中)', 10], 
     ['轉寄配送中', 13], 
     ['調查處理中', 14], 
     ['暫置營業所保管中（請聯絡黑貓宅急便）', 15], 
     ['暫置轉運中心保管中（請聯絡黑貓宅急便）', 16], 
     ['退貨', 17], 
     ['--', 18], 
     ['當配轉運中', 19],   
     ['當配轉運中', 20],  
     ['調查處理中', 21],  
     ['調查處理中', 22],  
     ['地址不明（調查處理中)', 23],  
     ['航班延誤（調查處理中）', 25],  
     ['空運中', 27],  
     ['--', 91],  
     ['--', 92],  
     ['客樂得貨物退回中', 301],  
     ['調查處理中', 302],  
     ['調查處理中', 303],  
     ['--', 391],  
     ['退貨完成', 399]]
  end  
      
  def expressComingDate(hash={})    
    t_15_30 = Time.new(hash[:checked_time].year, hash[:checked_time].month, 
                       hash[:checked_time].day, 15, 30, 00)       
    if t_15_30 >= hash[:checked_time] 
       if hash[:words]       
        ' '+(hash[:checked_time]+1.day).to_date.to_s+' '
       else 
        (hash[:checked_time]+1.day).to_date.to_s
       end         
    else
       if hash[:words]
        ' '+(hash[:checked_time]+2.day).to_date.to_s+' '  
       else 
        (hash[:checked_time]+2.day).to_date.to_s
       end 
    end
  end    
end
