module ProductsHelper
  def unitOptions
    [['台斤', GLOBAL_VAR['UNIT_CATTY']], 
     ['公斤', GLOBAL_VAR['UNIT_KG']],
     ['顆', GLOBAL_VAR['UNIT_STAR']]]
  end
end
