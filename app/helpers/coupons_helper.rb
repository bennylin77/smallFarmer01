module CouponsHelper

  def coupons
    coupons = 0
    available_coupons = current_user.coupons.where('amount <> 0 and available_c = true')
    expiration_coupons = available_coupons.where('kind <> ? ', GLOBAL_VAR['COUPON_CHECK_OUT'])
    expiration_coupons.order('id').each do |e_c|
      unless ((Time.zone.now - e_c.created_at).to_i / 1.day) > GLOBAL_VAR['COUPON_DURATION_OF_VALIDITY']                              
        coupons = coupons + e_c.amount
      end
    end  
    normal_coupons = available_coupons.where('kind = ? ', GLOBAL_VAR['COUPON_CHECK_OUT'])
    normal_coupons.order('id').each do |n_c|                                
      coupons = coupons + n_c.amount       
    end        
    coupons.to_i
  end
  
  def couponSource(coupon)
    case coupon.kind     
    when GLOBAL_VAR['COUPON_SIGN_UP']
      '驗證回饋'  
    when GLOBAL_VAR['COUPON_CHECK_OUT']  
      '消費回饋'      
    end
  end
   
  def couponExpired(coupon)
    case coupon.kind     
    when GLOBAL_VAR['COUPON_SIGN_UP']    
      created_date = coupon.created_at
      expired_date = (coupon.created_at+GLOBAL_VAR['COUPON_DURATION_OF_VALIDITY'].day).strftime("%Y-%m-%d %H:%M:%S")       
      if expired_date < Time.zone.now
        expired_date = expired_date.to_s + ' (已到期)'
      end
      simple_format( expired_date, class: 'text-danger')      
    when GLOBAL_VAR['COUPON_CHECK_OUT']  
      '無期限'      
    end    
  end 
   
end