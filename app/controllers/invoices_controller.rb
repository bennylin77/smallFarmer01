class InvoicesController < ApplicationController
  
  def index    
    render layout: 'users'    
  end  
  
  def createCOD  
    current_user.update_attributes(user_params)  
    invoice =  current_user.invoices.where(confirmed_c: false).first    
    current_user.carts.each do |c|
      order = Order.new
      order.invoice = invoice 
      order.product_boxing = c.product_boxing
      order.quantity = c.quantity
      c.product_boxing.product_pricings.order('quantity desc').each do |p|
        if c.quantity >= p.quantity 
          order.price = order.quantity*p.price
          break  
        end  
      end
      order.shipping_rates = order.quantity*GLOBAL_VAR['SHIPPING_RATES'] 
      order.status = GLOBAL_VAR['ORDER_STATUS_UNCONFIRMED']       
      order.save!
      invoice.amount = invoice.amount + order.price + order.shipping_rates
    end
    invoice.save! 
    #Coupons
    candidate_coupons = candidateCoupons(coupons_using: params[:coupons_using].to_i )
    if candidate_coupons
      coupons_using_left = params[:coupons_using].to_i
      candidate_coupons.each do |c_c|
        if coupons_using_left != 0  or c_c.coupon.user == current_user    
          i_c_l = InvoiceCouponList.new
          i_c_l.invoice = invoice
          i_c_l.coupon = c_c[:coupon]
          i_c_l.amount = c_c[:amount]
          i_c_l.save!
          c_c[:coupon].amount = c_c[:coupon].amount - c_c[:amount]   
          c_c[:coupon].amount == 0 ? c_c[:coupon].available_c = false : c_c[:coupon].available_c = true 
          c_c[:coupon].save! 
          coupons_using_left = coupons_using_left - c_c[:amount]
        end
      end
    end
    current_user.carts.destroy_all
    invoice.payment_method = GLOBAL_VAR['PAYMENT_METHOD_COD']    
    invoice.confirmed_c = true
    invoice.save!   
    
 
    redirect_to  controller: 'invoices' , action: 'finished'     
  end  
  
  def createCredit
    
  end 
  
  private   
  
    def candidateCoupons( hash={} )
      candidate_coupons = Array.new
      coupons_using_left = hash[:coupons_using]              
      available_coupons = current_user.coupons.where('amount <> 0 and available_c = true')
      # check available amount
      available_amount = 0
      available_coupons.each do |a_c|
        available_amount = available_amount + a_c.amount     
      end
      unless available_amount < hash[:coupons_using] or hash[:coupons_using] < 0 or !hash[:coupons_using].is_a? Numeric     
        # check expiration coupons
        if coupons_using_left > 0           
          expiration_coupons = available_coupons.where('kind <> ? ', GLOBAL_VAR['COUPON_CHECK_OUT'])
          expiration_coupons.order('id').each do |e_c|
            unless ((Time.now - e_c.created_at).to_i / 1.day) > GLOBAL_VAR['COUPON_DURATION_OF_VALIDITY']                              
              if coupons_using_left - e_c.amount > 0
                candidate_coupons.push({amount: e_c.amount, coupon: e_c})
                coupons_using_left = coupons_using_left- e_c.amount               
              elsif 
                candidate_coupons.push({amount: coupons_using_left, coupon: e_c})
                coupons_using_left = coupons_using_left- e_c.amount                             
                break                                                            
              end
            else
              e_c.available_c = false
              e_c.save!            
            end        
          end
        end
        # check normal coupons 
        if coupons_using_left > 0       
          normal_coupons = available_coupons.where('kind = ? ', GLOBAL_VAR['COUPON_CHECK_OUT'])
          normal_coupons.order('id').each do |n_c|                                
            if coupons_using_left - n_c.amount > 0           
              candidate_coupons.push({amount: n_c.amount, coupon: n_c})
              coupons_using_left = coupons_using_left - n_c.amount
            elsif coupons_using_left - n_c.amount <= 0
              candidate_coupons.push({amount: coupons_using_left, coupon: n_c})
              coupons_using_left = coupons_using_left - n_c.amount            
              break                                                            
            end     
          end
        end  
        candidate_coupons
      end    
    end 
    
    def user_params
      accessible = [:first_name, :last_name, addresses_attributes:[:id, :first_name, :last_name, :phone_no, :postal, :county, :district, :address, :country],
                                             invoices_attributes:[:id, :receiver_last_name, :receiver_first_name, :receiver_phone_no, :receiver_postal, 
                                                                  :receiver_county, :receiver_district, :receiver_address, :receiver_country]]
      params.require(:user).permit(accessible)    
    end      
end