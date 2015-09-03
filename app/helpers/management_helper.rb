module ManagementHelper
  def discountPercentageOptions
    [['無', GLOBAL_VAR['DISCOUNT_NONE']],
     ['95折', GLOBAL_VAR['DISCOUNT_FIVE_PERCENT']], 
     ['9折', GLOBAL_VAR['DISCOUNT_TEN_PERCENT']]]
  end    
end
