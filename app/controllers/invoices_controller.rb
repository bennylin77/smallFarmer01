class InvoicesController < ApplicationController
  def index    
    render layout: 'users'    
  end  
  
  
  def createCOD  
    candidate_coupons = candidateCoupons(coupons_using: params[:coupons_using].to_i )
    #coupons_using_left = hash[:coupons_using]      
    params[:user][:addresses_attributes]['0'][:phone_no] = params[:phone_no_full]
    params[:user][:invoices_attributes]['0'][:receiver_phone_no] = params[:receiver_phone_no_full]        
    current_user.update_attributes(user_params)  
    invoice =  current_user.invoices.where(confirm_at: false).first
    
=begin    
    current_user.carts.each do |c|
      order = Oredr.new
      order.receiver_last_name = params[:user][:orders_attributes]['0'][:receiver_last_name]
      order.receiver_first_name = params[:user][:orders_attributes]['0'][:receiver_first_name]
      order.receiver_phone_no = params[:user][:orders_attributes]['0'][:receiver_phone_no_full]
      order.receiver_receiver_postal = params[:user][:orders_attributes]['0'][:receiver_receiver_postal]
      order.receiver_receiver_county = params[:user][:orders_attributes]['0'][:receiver_receiver_county]
      order.receiver_receiver_district = params[:user][:orders_attributes]['0'][:receiver_receiver_district]
      order.receiver_receiver_address = params[:user][:orders_attributes]['0'][:receiver_receiver_address]
      order.user = current_user
      order.product_boxing = c.product_boxing
      order.quantity = c.quantity
      c.product_boxing.product_pricings.order('quantity desc').each do |p|
        if c.quantity >= p.quantity 
          order.price = order.quantity*p.price
          break  
        end  
      end  
      order.save!
      #use coupon
      remaining_order_price = order.price
      remaining_candidate_coupons = Array.new
      candidate_coupons.each do |c_c|    
        if remaining_order_price == 0
          remaining_candidate_coupons << c_c           
          break        
        elsif c_c.amount <= remaining_order_price
          order_coupon_list = OrderCouponList.new()
          order_coupon_list.coupon = c_c
          order_coupon_list.order = order
          order_coupon_list.amount = c_c.amount
          order_coupon_list.save!
          remaining_order_price = remaining_order_price - c_c.amount          
          c_c.amount = 0
          c_c.save!          
        elsif c_c.amount > remaining_order_price
          order_coupon_list = OrderCouponList.new()
          order_coupon_list.coupon = c_c
          order_coupon_list.order = order
          order_coupon_list.amount = remaining_order_price
          order_coupon_list.save! 
          c_c.amount = c_c.amount - remaining_order_price                  
          remaining_order_price = 0
          c_c.save!          
          remaining_candidate_coupons << c_c                    
        end    

      
      
      end
      
      
    end
    
    
    

    # coupon_using = params[:coupons_using]
=end    
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
            unless ((Time.now - e_c.created_at).to_i / 1.day) > 30                               
              if coupons_using_left - e_c.amount > 0
                candidate_coupons.push(e_c)
                coupons_using_left = coupons_using_left- e_c.amount               
              elsif 
                candidate_coupons.push(e_c)
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
              candidate_coupons.push(n_c)
              coupons_using_left = coupons_using_left - n_c.amount
            elsif coupons_using_left - n_c.amount <= 0
              candidate_coupons.push(n_c)
              coupons_using_left = coupons_using_left - n_c.amount            
              break                                                            
            end     
          end
        end  
        #logger.info coupons_using_left        
        #candidate_coupons.each do |ee|
        #  logger.info ee.id
        #  logger.info ee.amount  
        #end  
        # let's use coupons
        candidate_coupons
      else
        flash[:error] = '回饋金錯誤' 
        redirect  root_url
      end    
    end 
    
    def user_params
      accessible = [:first_name, :last_name, addresses_attributes:[:id, :first_name, :last_name, :phone_no, :postal, :county, :district, :address, :country],
                                             invoices_attributes:[:id, :receiver_last_name, :receiver_first_name, :receiver_phone_no, :receiver_postal, 
                                                                  :receiver_county, :receiver_district, :receiver_address, :receiver_country]]
      params.require(:user).permit(accessible)    
    end      
end