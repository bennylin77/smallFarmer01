module ProductsHelper
  
  def priceWithShippingRates(hash={})
    price = 0     
    hash[:product_boxing].product_pricings.order('quantity desc').each do |p|
      if hash[:quantity] >= p.quantity     
        shipping_rate_quantity = 1
        if p.quantity != 1   
          shipping_rate_quantity = p.quantity
        end
        price = hash[:quantity]*((p.price + shippingRates(cold_chain: hash[:product_boxing].product.cold_chain, box_size: hash[:product_boxing].size, quantity: shipping_rate_quantity))*hash[:product_boxing].product.discount).ceil     
        break  
      end  
    end      
    price
  end

  def shippingRates(hash={})
    shipping_rates = 0
    case hash[:box_size]
    when GLOBAL_VAR['BOX_SIZE_FIRST']
      if hash[:quantity] == 1     
        shipping_rates = (hash[:cold_chain] != GLOBAL_VAR['SHIPMENT_TEMP_NORMAL']) ? (GLOBAL_VAR['SHIPPING_RATES_FIRST'] + GLOBAL_VAR['SHIPPING_RATES_COLD_CHAIN']):GLOBAL_VAR['SHIPPING_RATES_FIRST'];
      else
        shipping_rates = (hash[:cold_chain] != GLOBAL_VAR['SHIPMENT_TEMP_NORMAL']) ? (GLOBAL_VAR['BARGAIN_SHIPPING_RATES_FIRST'] + GLOBAL_VAR['SHIPPING_RATES_COLD_CHAIN']):GLOBAL_VAR['BARGAIN_SHIPPING_RATES_FIRST'];                  
      end  
    when GLOBAL_VAR['BOX_SIZE_SECOND']
      if hash[:quantity] == 1     
        shipping_rates = (hash[:cold_chain] != GLOBAL_VAR['SHIPMENT_TEMP_NORMAL']) ? (GLOBAL_VAR['SHIPPING_RATES_SECOND'] + GLOBAL_VAR['SHIPPING_RATES_COLD_CHAIN']):GLOBAL_VAR['SHIPPING_RATES_SECOND'];
      else
        shipping_rates = (hash[:cold_chain] != GLOBAL_VAR['SHIPMENT_TEMP_NORMAL']) ? (GLOBAL_VAR['BARGAIN_SHIPPING_RATES_SECOND'] + GLOBAL_VAR['SHIPPING_RATES_COLD_CHAIN']):GLOBAL_VAR['BARGAIN_SHIPPING_RATES_SECOND'];                  
      end 
    when GLOBAL_VAR['BOX_SIZE_THIRD']
        shipping_rates = (hash[:cold_chain] != GLOBAL_VAR['SHIPMENT_TEMP_NORMAL']) ? (GLOBAL_VAR['SHIPPING_RATES_THIRD'] + GLOBAL_VAR['SHIPPING_RATES_COLD_CHAIN']):GLOBAL_VAR['SHIPPING_RATES_THIRD'];
    end
  end
    
  def tempOptions
    [['常溫', GLOBAL_VAR['SHIPMENT_TEMP_NORMAL']], 
     ['冷藏 (+'+GLOBAL_VAR['SHIPPING_RATES_COLD_CHAIN'].to_s+'元)', GLOBAL_VAR['SHIPMENT_TEMP_REFRIGERATION']],
     ['冷凍 (+'+GLOBAL_VAR['SHIPPING_RATES_COLD_CHAIN'].to_s+'元)', GLOBAL_VAR['SHIPMENT_TEMP_FREEZING']]]
  end  

  def boxSizeOptions
    [['A+B+C = 60公分以下 (一箱'+GLOBAL_VAR['SHIPPING_RATES_FIRST'].to_s+'元，兩箱以上每箱'+GLOBAL_VAR['BARGAIN_SHIPPING_RATES_FIRST'].to_s+'元)', GLOBAL_VAR['BOX_SIZE_FIRST']], 
     ['A+B+C = 61公分~90公分 (一箱'+GLOBAL_VAR['SHIPPING_RATES_SECOND'].to_s+'元，兩箱以上每箱'+GLOBAL_VAR['BARGAIN_SHIPPING_RATES_SECOND'].to_s+'元)', GLOBAL_VAR['BOX_SIZE_SECOND']], 
     ['A+B+C = 91公分~120公分 (一箱'+GLOBAL_VAR['SHIPPING_RATES_THIRD'].to_s+'元，兩箱以上無折扣)', GLOBAL_VAR['BOX_SIZE_THIRD']]]
  end

  def boxSizeWithoutNotationOptions
    [['60公分以下', GLOBAL_VAR['BOX_SIZE_FIRST']], 
     ['61公分~90公分', GLOBAL_VAR['BOX_SIZE_SECOND']], 
     ['91公分~120公分', GLOBAL_VAR['BOX_SIZE_THIRD']]]
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

  def shipmentReviewBg(score)
    case score
    when GLOBAL_VAR['ORDER_SHIPMENT_REVIEW_FAST']
      'shipment_review_fast_bg'
    when GLOBAL_VAR['ORDER_SHIPMENT_REVIEW_COMMON']
      'shipment_review_common_bg'
    when GLOBAL_VAR['ORDER_SHIPMENT_REVIEW_SLOW']       
      'shipment_review_slow_bg'         
    end            
  end
  
  def shipmentReviewText(score)
    case score
    when GLOBAL_VAR['ORDER_SHIPMENT_REVIEW_FAST']
      'shipment_review_fast'
    when GLOBAL_VAR['ORDER_SHIPMENT_REVIEW_COMMON']
      'shipment_review_common'
    when GLOBAL_VAR['ORDER_SHIPMENT_REVIEW_SLOW']       
      'shipment_review_slow'         
    end            
  end   
end
