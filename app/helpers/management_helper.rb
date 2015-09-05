module ManagementHelper
  def discountPercentageOptions
    [['無', GLOBAL_VAR['DISCOUNT_NONE']],
     ['95折', GLOBAL_VAR['DISCOUNT_FIVE_PERCENT']], 
     ['9折', GLOBAL_VAR['DISCOUNT_TEN_PERCENT']]]
  end  
  
  def billPeriodOptions
    options = []  
    Time.now.year.downto(2015){ |i| 
      if i!=Time.now.year
        12.downto(1){ |j| 
          options<<[ Date.civil( i, j, 16).midnight.strftime("%Y-%m-%d")+'~'+(( Date.civil(i, j, -1)+1 ).midnight-1).strftime("%Y-%m-%d"), Date.civil( i, j, 16).midnight.strftime('%Y-%m-%d %H:%M:%S')]        
          options<<[ Date.civil( i, j, 1).midnight.strftime("%Y-%m-%d")+'~'+(Date.civil(i, j, 16).midnight-1).strftime("%Y-%m-%d"), Date.civil( i, j, 1).midnight.strftime('%Y-%m-%d %H:%M:%S')]
        }
      else
        Time.now.month.downto(1){ |j| 
          options<<[ Date.civil( i, j, 16).midnight.strftime("%Y-%m-%d")+'~'+(( Date.civil(i, j, -1)+1 ).midnight-1).strftime("%Y-%m-%d"), Date.civil( i, j, 16).midnight.strftime('%Y-%m-%d %H:%M:%S')]        
          options<<[ Date.civil( i, j, 1).midnight.strftime("%Y-%m-%d")+'~'+(Date.civil(i, j, 16).midnight-1).strftime("%Y-%m-%d"), Date.civil( i, j, 1).midnight.strftime('%Y-%m-%d %H:%M:%S')]
        }        
      end    
    }  
    options   
  end
  
    
end
