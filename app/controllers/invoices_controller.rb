class InvoicesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:allpayCreditNotify]
  before_action :set_invoice, only: [:allpayCredit, :finished]
  
  def index    
    @invoices = current_user.invoices.paginate(page: params[:page], per_page: 5).order('id DESC')    
    render layout: 'users'    
  end  
  
  def create  
    current_user.update_attributes(user_params)  
    invoice =  current_user.invoices.where(confirmed_c: false).last 
    #Orders       
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
    invoice.payment_method = params[:payment_method]  
    invoice.save!      
    if invoice.payment_method == GLOBAL_VAR['PAYMENT_METHOD_TCAT_COD']
      invoice.confirmed_c = true
      invoice.save!  
      invoice.orders.each do |o|
        user = o.product_boxing.product.company.user
        user.notifications<< Notification.create(category: GLOBAL_VAR['NOTIFICATION_PRODUCT'], sub_category: GLOBAL_VAR['NOTIFICATION_SUB_NEW_ORDER'], 
                                                 order_id: o.id)
        user.save!  
      end            
      redirect_to  controller: 'invoices' , action: 'finished', id: invoice.id 
    elsif invoice.payment_method == GLOBAL_VAR['PAYMENT_METHOD_ALLPAY_CREDIT']
      redirect_to  controller: 'invoices', action: 'allpayCredit', id: invoice.id       
    end            
  end  
  
  def allpayCredit   
    discount = 0 
    @invoice.invoice_coupon_lists.each do |i_c_l|
        discount = discount + i_c_l.amount
    end    
    item_name = []
    @invoice.orders.each do |o|                            
      item_name << o.product_boxing.product.name+'x'+o.quantity.to_s+'箱'    
    end   
    item_name = item_name.join("#")    
    merchant_trade_no = @invoice.id.to_s+'AT'+Time.now.strftime("%Y%m%d%H%M%S").to_s
    @allpay_var = { MerchantID: Rails.configuration.allpay_merchant_id,
                    MerchantTradeNo: merchant_trade_no,
                    MerchantTradeDate: @invoice.created_at.strftime("%Y/%m/%d %H:%M:%S"), 
                    PaymentType: "aio",
                    TradeDesc: "歐付寶付款",
                    TotalAmount: @invoice.amount.to_i - discount.to_i,
                    ItemName: item_name,       
                    ReturnURL: Rails.configuration.allpay_return_url,
                    ChoosePayment: "Credit",
                    ClientBackURL: Rails.configuration.smallfarmer01_host+'/invoices/finished?id='+@invoice.id.to_s}    
    #CheckMacValue
    result = @allpay_var.to_a.sort.map do |key, value|
      "#{key}=#{value}"
    end
    result = result.join("&")
    url_encode_downcase = CGI::escape("HashKey=" + Rails.configuration.allpay_hash_key + "&" + result + "&HashIV=" + Rails.configuration.allpay_hash_iv).downcase   
    @check_mac_value = Digest::MD5.hexdigest(url_encode_downcase).upcase     
    @invoice.allpay_merchant_trade_no = merchant_trade_no
    @invoice.save!
  end
  
  def finished
    
  end
  
  def allpayCreditNotify
    if macValueOk? # we still need to check domain   
      if params[:RtnCode] == '1' # trade success or not
        invoice = Invoice.where(allpay_merchant_trade_no: params[:MerchantTradeNo]).first
        discount = 0 
        invoice.invoice_coupon_lists.each do |i_c_l|
            discount = discount + i_c_l.amount
        end           
        if params[:TradeAmt].to_i == (invoice.amount - discount).to_i # amount right or not           
          invoice.paid_at = params[:PaymentDate]
          invoice.payment_charge_fee = params[:PaymentTypeChargeFee]      
          invoice.allpay_trade_no = params[:TradeNo] 
          invoice.paid_c = true
          invoice.confirmed_c = true          
          invoice.save!   
        end
        
        invoice.orders.each do |o|
          user = o.product_boxing.product.company.user
          user.notifications<< Notification.create(category: GLOBAL_VAR['NOTIFICATION_PRODUCT'], sub_category: GLOBAL_VAR['NOTIFICATION_SUB_NEW_ORDER'], 
                                                   order_id: o.id)
          user.save!  
        end
        
      end
      render text: "1|OK"      
    else  
      render text: "0|ErrorMessage"
    end   
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

    def macValueOk?
      params_copy = params.dup
      params_to_go = params_copy.except(:CheckMacValue, :action, :controller)
      raw_data = params_to_go.sort.map do |x, y|
        "#{x}=#{y}"
      end.join('&')
      url_encode_downcase = CGI::escape("HashKey=" + Rails.configuration.allpay_hash_key + "&" + raw_data + "&HashIV=" + Rails.configuration.allpay_hash_iv).downcase   
      my_mac = Digest::MD5.hexdigest(url_encode_downcase)   
      params_no_mac = params[:CheckMacValue]
      if my_mac == params_no_mac.to_s.downcase
        return true
      else
        return false
      end
    end

    def set_invoice
      @invoice = Invoice.find(params[:id])
    end
    
    def user_params
      accessible = [:first_name, :last_name, addresses_attributes:[:id, :first_name, :last_name, :phone_no, :postal, :county, :district, :address, :country],
                                             invoices_attributes:[:id, :receiver_last_name, :receiver_first_name, :receiver_phone_no, :receiver_postal, 
                                                                  :receiver_county, :receiver_district, :receiver_address, :receiver_country]]
      params.require(:user).permit(accessible)    
    end      
end