class OrdersController < ApplicationController
  
  def userIndex    
    render layout: 'users'    
  end
  
  def companyIndex    
    render layout: 'companies'      
  end
  
  def checkout   
    unless params[:user].blank?
      current_user.assign_attributes(user_params)   
    else
      current_user.orders.build()
    end                              
    @coupon_using = params[:coupons_using]
    @payment_method = params[:payment_method]
    @agree = params[:agree]    
  end
  
  def confirmCheckout   
    params[:user][:addresses_attributes]['0'][:phone_no] = params[:phone_no_full]
    params[:user][:orders_attributes]['0'][:receiver_phone_no] = params[:receiver_phone_no_full]    
    current_user.assign_attributes(user_params)  
    @coupon_using = params[:coupons_using]
    @payment_method = params[:payment_method]
    @agree = params[:agree]
    
    current_user.valid?
    if @payment_method.blank?  
      current_user.errors.add(:payment_method, "請選擇付款方式")
    end    
    unless @agree  
      current_user.errors.add(:agree, "請勾選 小農1號 電子商務約定條款")
    end
    if current_user.errors.any?
      render 'checkout'
    else
    end
  end  
  
  def createCOD
    #current_user.update_attributes(user_params)  
    order = current_user.orders.where(confirm_c: false).first 
    
    handleCoupons(order: order, coupons_using: params[:coupons_using].to_i )

    # coupon_using = params[:coupons_using]
    
    redirect_to  controller: 'orders' , action: 'finished' 
  end  
  
  def createCredit
    
  end
  
  private   
  
    def handleCoupons( hash={} )
      candidate_coupons = Array.new
      coupons_using_left = hash[:coupons_using]              
      available_coupons = current_user.coupons.where('amount <> 0 and available_c = true')
      # check available amount
      available_amount = 0
      available_coupons.each do |a_c|
        available_amount = available_amount + a_c.amount     
      end
      unless available_amount < hash[:coupons_using] or hash[:coupons_using] < 0 or !hash[:coupons_using].is_a? Numeric     
        # check expiration coupon
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
        # check normal coupon 
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
        
        
      else
        flash[:error] = '回饋金錯誤' 
        redirect  root_url
      end    
    end
  
    def user_params
      #params[:user][:addresses_attributes]['0'][:phone_no] = params[:phone_no_full]
      #params[:user][:orders_attributes]['0'][:receiver_phone_no] = params[:receiver_phone_no_full]
      accessible = [ :first_name, :last_name, :avatar, addresses_attributes:[:id, :first_name, :last_name, :phone_no, :postal, :county, :district, :address, :country],
                                                       orders_attributes:[:id, :receiver_last_name, :receiver_first_name, :receiver_phone_no, :receiver_postal, 
                                                                          :receiver_county, :receiver_district, :receiver_address, :receiver_country]]# extend with your own params
      params.require(:user).permit(accessible)
    end  
end
