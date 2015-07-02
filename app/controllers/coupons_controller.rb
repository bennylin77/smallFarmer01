class CouponsController < ApplicationController
  
  def index
    render layout: 'users'           
  end    
  
  def showCoupons
    coupons = 0
    available_coupons = current_user.coupons.where('amount <> 0 and available_c = true')
    expiration_coupons = available_coupons.where('kind <> ? ', GLOBAL_VAR['COUPON_CHECK_OUT'])
    expiration_coupons.order('id').each do |e_c|
      unless ((Time.now - e_c.created_at).to_i / 1.day) > GLOBAL_VAR['COUPON_DURATION_OF_VALIDITY']                              
        coupons = coupons + e_c.amount
      end
    end  
    normal_coupons = available_coupons.where('kind = ? ', GLOBAL_VAR['COUPON_CHECK_OUT'])
    normal_coupons.order('id').each do |n_c|                                
      coupons = coupons + n_c.amount       
    end        
    render json: { quantity: coupons }    
  end  
end
