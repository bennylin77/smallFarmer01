module ProductsHelper
  
  def tempOptions
    [['常溫', GLOBAL_VAR['SHIPMENT_TEMP_NORMAL']], 
     ['冷藏', GLOBAL_VAR['SHIPMENT_TEMP_REFRIGERATION']],
     ['冷凍', GLOBAL_VAR['SHIPMENT_TEMP_FREEZING']]]
  end  

  def boxSizeOptions
    [['小等於90公分', GLOBAL_VAR['BOX_SIZE_FIRST']], 
     ['91公分~120公分', GLOBAL_VAR['BOX_SIZE_SECOND']]]
  end
  
  def unitOptions
    [['台斤', GLOBAL_VAR['UNIT_CATTY']], 
     ['公斤', GLOBAL_VAR['UNIT_KG']],
     ['顆', GLOBAL_VAR['UNIT_STAR']],
     ['包', GLOBAL_VAR['UNIT_BAO']],
     ['罐', GLOBAL_VAR['UNIT_CAN']]]
  end
  
  def reviewBg(score)
    case score
    when GLOBAL_VAR['ORDER_REVIEW_DELICIOUS']
      'review_delicious_bg'
    when GLOBAL_VAR['ORDER_REVIEW_TASTY']
      'review_tasty_bg'
    when GLOBAL_VAR['ORDER_REVIEW_COMMON']     
      'review_common_bg'    
    when GLOBAL_VAR['ORDER_REVIEW_UNAPPEALING']     
      'review_unappealing_bg'       
    end            
  end
  
  def reviewText(score)
    case score
    when GLOBAL_VAR['ORDER_REVIEW_DELICIOUS']
      'review_delicious'
    when GLOBAL_VAR['ORDER_REVIEW_TASTY']
      'review_tasty'
    when GLOBAL_VAR['ORDER_REVIEW_COMMON']       
      'review_common'    
    when GLOBAL_VAR['ORDER_REVIEW_UNAPPEALING']     
      'review_unappealing'       
    end            
  end  
end
