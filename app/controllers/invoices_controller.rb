class InvoicesController < ApplicationController
  before_filter :authenticate_user!, except: [:allpayNotify, :allpayPaymentInfoNotify]   
  skip_before_action :verify_authenticity_token, only: [:allpayNotify, :allpayPaymentInfoNotify]
  
  before_action :set_invoice, only: [:allpayCredit, :allpayATM, :allpayCVS, :finished, :cancel]
  before_action :paid?, only: [:allpayCredit, :allpayATM, :allpayCVS]
  before_action :expired?, only: [:allpayCredit, :allpayATM, :allpayCVS]   
  before_action :emptyCarts?, only: [:create, :checkout, :confirmCheckout]
    
  def index    
    @invoices = current_user.invoices.paginate(page: params[:page], per_page: 1).order('id DESC')    
    render layout: 'users'    
  end  
  
  def create  
    #inventory AND available AND payment method
    current_user.carts.each do |c|        
      unpaid = Order.joins(product_boxing: {}, invoice: {} ).where('product_boxings.id = ? and invoices.confirmed_c = ? and invoices.allpay_expired_at > ? ', c.product_boxing.id, false, Time.now ).sum(:quantity)     
      if c.product_boxing.product.inventory - unpaid - c.quantity < 0
        flash[:warning] = c.product_boxing.product.name + '庫存剩'+(c.product_boxing.product.inventory - unpaid).to_s+'箱'
      elsif !c.product_boxing.product.available_c
        flash[:warning] = c.product_boxing.product.name + '已下架'       
      end 
    end
    if flash[:warning]
      redirect_to root_url  
    else  
      # user_attributes   
      current_user.update_attributes(user_params)          
      # address
      if current_user.addresses.first 
         address = current_user.addresses.first 
      else
         address = Address.new
      end     
      address.update( first_name: params[:receiver_first_name], last_name: params[:receiver_last_name],
                      phone_no: params[:receiver_phone_no], postal: params[:receiver_postal],
                      county: params[:receiver_county], district: params[:receiver_district],
                      address: params[:receiver_address], user: current_user)      
      invoice =  Invoice.new
      invoice.user = current_user
      invoice.save! 
      #Orders       
      current_user.carts.each do |c|
        order = Order.new
        order.invoice = invoice 
        order.product_boxing = c.product_boxing
        order.quantity = c.quantity
        order.cold_chain = c.product_boxing.product.cold_chain
        order.size = c.product_boxing.size        
        c.product_boxing.product_pricings.order('quantity desc').each do |p|
          if c.quantity >= p.quantity 
            order.price = order.quantity*p.price
            break  
          end  
        end
        order.shipping_rates = order.quantity*shippingRates(cold_chain: c.product_boxing.product.cold_chain, size: c.product_boxing.size)
        order.save!      
        receiver_address = ReceiverAddress.new
        receiver_address.update( first_name: params[:receiver_first_name], last_name: params[:receiver_last_name],
                                 phone_no: params[:receiver_phone_no], postal: params[:receiver_postal],
                                 county: params[:receiver_county], district: params[:receiver_district],
                                 address: params[:receiver_address])            
        shipment = Shipment.new
        shipment.update( quantity: order.quantity, status: GLOBAL_VAR['ORDER_STATUS_UNCONFIRMED'],            
                         order: order, receiver_address: receiver_address )
        invoice.amount = invoice.amount + order.price + order.shipping_rates
      end      
      #Coupons AND payment method
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
        
        if invoice.amount - params[:coupons_using].to_i == 0
          invoice.payment_method = GLOBAL_VAR['PAYMENT_METHOD_NO_NEED'] 
        else          
          invoice.payment_method = params[:payment_method]  
        end    
      else
        invoice.payment_method = params[:payment_method]  
      end       
      # END 
      invoice.allpay_expired_at = Time.now + 1.day                              
      current_user.carts.destroy_all   
      invoice.save!  
      
      if invoice.payment_method == GLOBAL_VAR['PAYMENT_METHOD_ALLPAY_CREDIT']
        redirect_to  controller: 'invoices', action: 'allpayCredit', id: invoice.id                          
      elsif invoice.payment_method == GLOBAL_VAR['PAYMENT_METHOD_ALLPAY_ATM'] 
        redirect_to  controller: 'invoices', action: 'allpayATM', id: invoice.id                          
      elsif invoice.payment_method == GLOBAL_VAR['PAYMENT_METHOD_ALLPAY_CVS']
        invoice.amount = invoice.amount + GLOBAL_VAR['ALLPAY_CVS_FEE']
        invoice.save!
        redirect_to  controller: 'invoices', action: 'allpayCVS', id: invoice.id                              
      elsif invoice.payment_method == GLOBAL_VAR['PAYMENT_METHOD_NO_NEED']
        invoice.paid_at = Time.now
        invoice.paid_c = true
        invoice.confirmed_c = true          
        invoice.save!
        invoice.orders.each do |o| 
          o.product_boxing.product.inventory = o.product_boxing.product.inventory - o.quantity
          o.product_boxing.product.save!  
          System.sendNewOrder(o).deliver   
          notify( o.product_boxing.product.company.user, { category: GLOBAL_VAR['NOTIFICATION_PRODUCT'], 
                                                           sub_category: GLOBAL_VAR['NOTIFICATION_SUB_NEW_ORDER'], 
                                                           order_id: o.id})                        
        end  
        System.sendPurchaseCompleted(invoice).deliver   
        notify( invoice.user, { category: GLOBAL_VAR['NOTIFICATION_PRODUCT'], 
                                sub_category: GLOBAL_VAR['NOTIFICATION_SUB_PURCHASE_COMPLETED'], 
                                invoice_id: invoice.id})
        redirect_to  controller: 'invoices', action: 'finished', id: invoice.id                                                                                          
      end      
    end       
  end  

# ================================== others ================================== #    

  def finished   
  end
  
  def cancel      
    if !@invoice.paid_c
      @invoice.canceled_c = true
      @invoice.canceled_at = Time.now
      @invoice.save!      
      #Coupons
      @invoice.invoice_coupon_lists.each do |i_c_l|
        coupon = i_c_l.coupon
        coupon.amount = coupon.amount + i_c_l.amount 
        coupon.amount == 0 ? coupon.available_c = false : coupon.available_c = true 
        coupon.save!
        i_c_l.destroy
      end      
      flash[:notice] = '訂單編號'+@invoice.id.to_s+' 已取消'    
    else  
      flash[:warning] = '訂單編號'+@invoice.id.to_s+' 已付款無法取消'      
    end
    redirect_to controller: :invoices, action: :index  
  end
  
  def checkout   
    unless params[:user].blank?
      current_user.assign_attributes(user_params)  
    end
                 
    if params[:receiver_first_name] and params[:receiver_last_name] and params[:receiver_phone_no] and
       params[:receiver_postal] and params[:receiver_county] and params[:receiver_district] and params[:receiver_address]
      @receiver_first_name = params[:receiver_first_name]    
      @receiver_last_name = params[:receiver_last_name]
      @receiver_phone_no = params[:receiver_phone_no]
      @receiver_postal = params[:receiver_postal]
      @receiver_county = params[:receiver_county]
      @receiver_district = params[:receiver_district]
      @receiver_address = params[:receiver_address]         
    elsif current_user.addresses.first 
      @receiver_first_name = current_user.addresses.first.first_name   
      @receiver_last_name = current_user.addresses.first.last_name
      @receiver_phone_no = current_user.addresses.first.phone_no
      @receiver_postal = current_user.addresses.first.postal
      @receiver_county = current_user.addresses.first.county
      @receiver_district = current_user.addresses.first.district
      @receiver_address = current_user.addresses.first.address 
    else   
    end    
    ##                     
    @coupon_using = params[:coupons_using]
    @payment_method = params[:payment_method]
    @agree = params[:agree]    
  end
  
  def confirmCheckout
    ## Assign attribute   
    params[:user][:phone_no] = params[:phone_no_full]
    current_user.update_attributes(user_params)  
    ##      
    @coupon_using = params[:coupons_using].to_i
    @payment_method = params[:payment_method]
    @agree = params[:agree]
    ##
    @receiver_first_name = params[:receiver_first_name]    
    @receiver_last_name = params[:receiver_last_name]
    @receiver_phone_no = params[:receiver_phone_no_full]
    @receiver_postal = params[:receiver_postal]
    @receiver_county = params[:receiver_county]
    @receiver_district = params[:receiver_district]
    @receiver_address = params[:receiver_address]
    ## inventory AND available AND payment method
    total_price = 0 
    current_user.carts.each do |c|        
      unpaid = Order.joins(product_boxing: {}, invoice: {} ).where('product_boxings.id = ? and invoices.confirmed_c = ? and invoices.allpay_expired_at > ? ', c.product_boxing.id, false, Time.now ).sum(:quantity)     
      if c.product_boxing.product.inventory - unpaid - c.quantity < 0
        current_user.errors.add('quantity_'+c.id.to_s, c.product_boxing.product.name + '庫存剩'+(c.product_boxing.product.inventory - unpaid).to_s+'箱')     
      elsif !c.product_boxing.product.available_c
        current_user.errors.add('quantity_'+c.id.to_s, c.product_boxing.product.name + '已下架')             
      end  
      c.product_boxing.product_pricings.order('quantity desc').each do |p|
        if c.quantity >= p.quantity 
          total_price = total_price + c.quantity*(p.price + shippingRates(cold_chain: p.product_boxing.product.cold_chain, size: p.product_boxing.size))         
        break  
        end  
      end
    end   
    
    final_total_price = total_price - @coupon_using    
    if @payment_method.blank? and final_total_price!= 0 
      current_user.errors.add(:payment_method, "請選擇付款方式")
    end       
    # Receiver
    if current_user.phone_no.blank?    
      current_user.errors.add(:phone_no, "請填寫 訂購人資訊-行動電話")
    end    
    if @receiver_last_name.blank?  
      current_user.errors.add(:receiver_last_name, "請填寫 收件人資訊-姓")
    end    
    if @receiver_first_name.blank?  
      current_user.errors.add(:receiver_first_name, "請填寫 收件人資訊-名")
    end    
    if @receiver_phone_no.blank?  
      current_user.errors.add(:receiver_phone_no, "請填寫 收件人資訊-聯絡電話")
    end
    if @receiver_postal.blank?  
      current_user.errors.add(:receiver_postal, "請填寫 收件人資訊-郵遞區號")
    end    
    if @receiver_county.blank?  
      current_user.errors.add(:receiver_county, "請填寫 收件人資訊-縣市")
    end        
    if @receiver_district.blank?  
      current_user.errors.add(:receiver_district, "請填寫 收件人資訊-鄉鎮市區")
    end        
    if @receiver_address.blank?  
      current_user.errors.add(:receiver_address, "請填寫 收件人資訊-詳細地址")
    end       
    # Others                    
    if @agree.blank?    
      current_user.errors.add(:agree, "請勾選 小農1號 電子商務約定條款")
    end  
    if current_user.errors.any?
      render 'checkout'
    end
  end    
  
# ================================== allpay ================================== #    
  
  def allpayNotify
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
          invoice.orders.each do |o| 
            o.product_boxing.product.inventory = o.product_boxing.product.inventory - o.quantity
            o.product_boxing.product.save!              
            System.sendNewOrder(o).deliver   
            notify( o.product_boxing.product.company.user, { category: GLOBAL_VAR['NOTIFICATION_PRODUCT'], 
                                                             sub_category: GLOBAL_VAR['NOTIFICATION_SUB_NEW_ORDER'], 
                                                             order_id: o.id})                          
          end  
          System.sendPurchaseCompleted(invoice).deliver   
          notify( invoice.user, { category: GLOBAL_VAR['NOTIFICATION_PRODUCT'], 
                                  sub_category: GLOBAL_VAR['NOTIFICATION_SUB_PURCHASE_COMPLETED'], 
                                  invoice_id: invoice.id})                                   
        end        
      end
      render text: "1|OK"      
    else  
      render text: "0|ErrorMessage"
    end   
  end

  def allpayPaymentInfoNotify
    if macValueOk? # we still need to check domain   
      if params[:RtnCode] == '2' # trade success or not
        invoice = Invoice.where(allpay_merchant_trade_no: params[:MerchantTradeNo]).first
        invoice.allpay_trade_no = params[:TradeNo] 
        invoice.allpay_bank_code = params[:BankCode] 
        invoice.allpay_v_account = params[:vAccount] 
        invoice.allpay_expired_at = params[:ExpireDate].to_time + 1.day - 1              
        invoice.save!           
      elsif params[:RtnCode] == '10100073'   
        invoice = Invoice.where(allpay_merchant_trade_no: params[:MerchantTradeNo]).first
        invoice.allpay_trade_no = params[:TradeNo] 
        invoice.allpay_expired_at = params[:ExpireDate]  
        invoice.allpay_payment_no = params[:PaymentNo]              
        invoice.save!               
      end
    end 
    render :nothing    
  end

  def allpayCredit   
    if @invoice.payment_method == GLOBAL_VAR['PAYMENT_METHOD_ALLPAY_CREDIT'] 
      discount = 0 
      @invoice.invoice_coupon_lists.each do |i_c_l|
          discount = discount + i_c_l.amount
      end    
      item_name = []
      @invoice.orders.each do |o|                            
        #item_name << o.product_boxing.product.name+'x'+o.quantity.to_s+'箱'    
        item_name <<  '小農一號商品編號'+o.id.to_s+'x'+o.quantity.to_s+'箱'    
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
      @invoice.allpay_expired_at = Time.now + 1.day
      @invoice.save!
    else  
        flash[:warning] = '訂單編號'+@invoice.id.to_s+' 付款方式不符合'
        redirect_to controller: :invoices, action: :index       
    end  
  end
  
  def allpayATM
    if @invoice.payment_method == GLOBAL_VAR['PAYMENT_METHOD_ALLPAY_ATM']    
      discount = 0 
      @invoice.invoice_coupon_lists.each do |i_c_l|
          discount = discount + i_c_l.amount
      end    
      item_name = []
      @invoice.orders.each do |o|                            
        #item_name << o.product_boxing.product.name+'x'+o.quantity.to_s+'箱'    
        item_name << '小農一號商品編號'+o.id.to_s+'x'+o.quantity.to_s+'箱'          
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
                      PaymentInfoURL: Rails.configuration.allpay_payment_info_url,
                      ChoosePayment: "ATM",
                      ExpireDate: 1,
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
    else  
        flash[:warning] = '訂單編號'+@invoice.id.to_s+' 付款方式不符合'
        redirect_to controller: :invoices, action: :index       
    end            
  end

  def allpayCVS
    if @invoice.payment_method == GLOBAL_VAR['PAYMENT_METHOD_ALLPAY_CVS']      
      discount = 0 
      @invoice.invoice_coupon_lists.each do |i_c_l|
          discount = discount + i_c_l.amount
      end    
      item_name = []
      @invoice.orders.each do |o|                            
        #item_name << o.product_boxing.product.name+'x'+o.quantity.to_s+'箱'    
        item_name << '小農一號商品編號'+o.id.to_s+'x'+o.quantity.to_s+'箱'          
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
                      PaymentInfoURL: Rails.configuration.allpay_payment_info_url,
                      ChoosePayment: "CVS",
                      Desc_1: item_name,
                      StoreExpireDate: 2160,
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
    else  
        flash[:warning] = '訂單編號'+@invoice.id.to_s+' 付款方式不符合'
        redirect_to controller: :invoices, action: :index       
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
              else 
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
            else
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

    def paid?
      if @invoice.paid_c
        flash[:warning] = '訂單編號'+@invoice.id.to_s+' 已付款'
        redirect_to controller: :invoices, action: :index          
      end      
    end
    
    def expired?
      if Time.now > @invoice.allpay_expired_at
        @invoice.orders.each do |o|
          unpaid = Order.joins(product_boxing: {}, invoice: {} ).where('product_boxings.id = ? and invoices.confirmed_c = ? and invoices.allpay_expired_at > ? ', o.product_boxing.id, false, Time.now ).sum(:quantity)     
          if o.product_boxing.product.inventory - unpaid - o.quantity < 0
            @invoice.canceled_c = true
            @invoice.canceled_at = Time.now
            @invoice.save!        
            flash[:alert] = o.product_boxing.product.name + '庫存剩'+(o.product_boxing.product.inventory - unpaid).to_s+'箱 此訂單已取消且無法付款'          
            redirect_to controller: 'invoices', action: 'index'            
          end
        end        
      end
    end

    def set_invoice
      @invoice = Invoice.find(params[:id])
    end
    
    def user_params
      accessible = [:first_name, :last_name, :email, :phone_no]
      params.require(:user).permit(accessible)    
    end      
end