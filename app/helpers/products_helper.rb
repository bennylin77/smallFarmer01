module ProductsHelper
  def unitOptions
    [['台斤', GLOBAL_VAR['UNIT_CATTY']], 
     ['公斤', GLOBAL_VAR['UNIT_KG']],
     ['顆', GLOBAL_VAR['UNIT_STAR']]]
  end
  
  def reviewBg(score)
    case score
    when GLOBAL_VAR['ORDER_REVIEW_DELICIOUS']
      'review_delicious_bg'
    when GLOBAL_VAR['ORDER_REVIEW_TASTY']
      'review_tasty_bg'
    when GLOBAL_VAR['ORDER_REVIEW_COMMON']     
      'review_common_bg'    
    end            
  end
end
