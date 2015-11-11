module ManagementHelper
  def discountPercentageOptions
    [['無折扣', GLOBAL_VAR['DISCOUNT_NONE']],
     ['95折', GLOBAL_VAR['DISCOUNT_FIVE_PERCENT']], 
     ['9折', GLOBAL_VAR['DISCOUNT_TEN_PERCENT']]]
  end  
  def organicOptions
    [['無', GLOBAL_VAR['ORGANIC_NONE']],
     ['慈心有機轉型', GLOBAL_VAR['ORGANIC_TOAF']]]
  end    
  
  def billPeriodOptions
    options = []  
    Time.zone.now.year.downto(2015){ |i| 
      if i!=Time.zone.now.year
        12.downto(1){ |j| 
          options<<[ Date.civil( i, j, 16).midnight.strftime("%Y-%m-%d")+'~'+(( Date.civil(i, j, -1)+1 ).midnight-1).strftime("%Y-%m-%d"), Date.civil( i, j, 16).midnight.strftime('%Y-%m-%d %H:%M:%S')]        
          options<<[ Date.civil( i, j, 1).midnight.strftime("%Y-%m-%d")+'~'+(Date.civil(i, j, 16).midnight-1).strftime("%Y-%m-%d"), Date.civil( i, j, 1).midnight.strftime('%Y-%m-%d %H:%M:%S')]
        }
      else
        Time.zone.now.month.downto(1){ |j| 
          options<<[ Date.civil( i, j, 16).midnight.strftime("%Y-%m-%d")+'~'+(( Date.civil(i, j, -1)+1 ).midnight-1).strftime("%Y-%m-%d"), Date.civil( i, j, 16).midnight.strftime('%Y-%m-%d %H:%M:%S')]        
          options<<[ Date.civil( i, j, 1).midnight.strftime("%Y-%m-%d")+'~'+(Date.civil(i, j, 16).midnight-1).strftime("%Y-%m-%d"), Date.civil( i, j, 1).midnight.strftime('%Y-%m-%d %H:%M:%S')]
        }        
      end    
    }  
    options   
  end
  
    
end
