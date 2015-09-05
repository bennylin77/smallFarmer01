class ManagementController < ApplicationController
  before_filter :authenticate_user!
  before_action :managementCheckUser

  before_action :set_bill, only: [:billShow]  
  before_action :set_order, only: []
  before_action :set_company, only: [:setCompany, :updateBankAccount, :updateBankCode]
  before_action :set_user, only: [:blockUser, :confirmPhoneNo]
  before_action :set_product, only: [:setProduct]
  
#======================# invoice #======================# 
  def invoices
    if params[:paid_c] 
      @paid_c = params[:paid_c] 
    else
      @paid_c = true
    end
    @invoices = Invoice.where(paid_c: @paid_c).paginate(page: params[:page], per_page: 60).order('id DESC')       
  end
  
#======================# order #======================#   
  def orders
    params[:called_smallfarmer_c] = params[:called_smallfarmer_c] == 'true' ? true : false    
    params[:called_logistics_c] = params[:called_logistics_c] == 'true' ? true : false    
    @called_smallfarmer_c = params[:called_smallfarmer_c]
    @called_logistics_c = params[:called_logistics_c]
      
    @orders = Order.joins(:invoice).where('called_smallfarmer_c = ? and called_logistics_c = ? and invoices.confirmed_c = 1', 
                                    params[:called_smallfarmer_c], params[:called_logistics_c]).all.paginate(page: params[:page], per_page: 30).order('id DESC')    
  end
  
  def exportOrders  
    unless params[:selected_orders].blank?
      @orders = []
      params[:selected_orders].each do |o|
        @orders << Order.find(o)
      end
      time_str = Time.now.strftime("%Y%m%d%H%M")    
      respond_to do |format|
         format.xls{
          response.headers['Content-Type'] = 'application/vnd.ms-excel; charset="utf-8" '
          response.headers['Content-Disposition'] = " attachment; filename=\"#{time_str}出貨單.xls\" "  
         }
      end  
    else
      flash[:warning] = '請勾取出貨單'
      redirect_to controller: 'management', action: 'orders', called_smallfarmer_c: true, called_logistics_c: false 
    end
  end  
  
  def uploadTracking
    workbook = Roo::Spreadsheet.open params[:file_data].path, extension: :xls
    workbook.each_with_pagename do |name, rows|
      rows.drop(2).each do |row|
        order = Order.find(row[1])
        #order.product_boxing.product.name
        if order.tracing_code.blank?
          order.tracing_code = row[0]
          order.save!
        end  
      end
    end    
    render json: {success: true}
  end
  
  def callLogistics
    params[:orders].each do |o|
      order = Order.find(o)
      order.called_logistics_c = true
      order.called_logistics_at = Time.now 
      order.save!
      order.shipments.each do |s|
        s.status = GLOBAL_VAR['ORDER_STATUS_CALLED_LOGISTICS'] 
        s.save!
      end  
    end
    render json: {success: true}
  end
  
  def problem
    params[:orders].each do |o|
      order = Order.find(o)
      order.problem_c = true
      order.problem_at = Time.now 
      order.save!    
    end
    render json: {success: true}      
  end
  
  def delivered 
    params[:orders].each do |o|          
      order = Order.find(o)
      
      order.shipments.each do |s|     
        if !s.delivered_c
          s.delivered_c = true
          s.delivered_at = Time.now 
          s.status = GLOBAL_VAR['ORDER_STATUS_DELIVERED'] 
          s.save! 
        end  
      end 
      #bills
      company = order.product_boxing.product.company   
      bill = company.bills.where("end_at >= ?", Time.now).first
      if bill.blank?
=begin        
        bill = Bill.new(title: '小農一號合作農場帳單表', user_first_name: company.user.first_name, user_last_name: company.user.last_name,
                        company_name: company.name , company_phone_no: company.phone_no, company_postal: company.postal,
                        company_county: company.county, company_district: company.district, company_address: company.address,
                        company_country: company.country, bank_code: company.bank_code, bank_account: company.bank_account)
=end 
        bill = Bill.new
        if Time.now.day <= 15          
          bill.begin_at = Date.civil(Time.now.year, Time.now.month, 1).midnight
          bill.end_at = Date.civil(Time.now.year, Time.now.month, 16).midnight-1
        else
          bill.begin_at = Date.civil(Time.now.year, Time.now.month, 16).midnight
          bill.end_at = ( Date.civil(Time.now.year, Time.now.month, -1)+1 ).midnight-1    
        end  
        bill.title = '小農一號合作農場帳單表'
        bill.company = company
      end
      bill.orders << order
      bill.save!       
      #review
      if order.review_at.blank? and order.invoice.notifications.where(category: GLOBAL_VAR['NOTIFICATION_PROMOTION'], sub_category: GLOBAL_VAR['NOTIFICATION_SUB_REVIEW']).count == 0
        delivered_all = true          
        order.invoice.orders.each do |i_o|
          i_o.shipments.each do |ss| 
            if !ss.delivered_c
              delivered_all = false       
            end
          end
        end      
        if delivered_all
          notify( order.invoice.user, { category: GLOBAL_VAR['NOTIFICATION_PROMOTION'], sub_category: GLOBAL_VAR['NOTIFICATION_SUB_REVIEW'], 
                                        invoice_id: order.invoice.id}) 
          System.sendReviewNotification(order.invoice).deliver           
          invoice = order.invoice
          discount = 0 
          invoice.invoice_coupon_lists.each do |i_c_l|
            discount = discount + i_c_l.amount
          end            
          data = { username: Rails.configuration.mitake_username, 
                   password: Rails.configuration.mitake_password,
                   dstaddr: invoice.user.phone_no.gsub(/^\+886/, '0'),
                   encoding: 'UTF8',
                   smbody: '您的小農訂單已送達，評價獲得'+((invoice.amount-discount)*0.04).round.to_s+'元回饋'+Rails.configuration.app_domain+'/notifications?category=3'                     
                   #smbody: '您的小農訂單已送達，評價獲得'+((invoice.amount-discount)*0.04).round.to_s+'元回饋'+'www.smallfarmer01.com/notifications?category=3'
                   }                                   
          result = RestClient.get( Rails.configuration.mitake_sm_send_get_url, params: data)                                                              
        end
      end    
               
    end   
    render json: {success: true}
  end  
#======================# bill #======================#   

  def bills
    if params[:begin_at]
      @begin_at = params[:begin_at].to_time 
    else  
      if Time.now.day <= 15   
        @begin_at = Date.civil(Time.now.year, Time.now.month, 1).midnight    
      else 
        @begin_at = Date.civil(Time.now.year, Time.now.month, 16).midnight 
      end  
    end
    @bills = Bill.where(begin_at: @begin_at)  
  end

  def billShow
  end


#======================# company #======================#      
  def companies
    params[:activated_c] = params[:activated_c] == 'true' ? true : false              
    @companies = Company.where('activated_c = ?', params[:activated_c]).all.paginate(page: params[:page], per_page: 60).order(priority: :desc)    
  end  
  
  def setCompany
    case params[:kind]
    when 'activate'
      params[:val] = params[:val] == 'true' ? true : false       
      if params[:val]
        @company.update_columns(activated_c: params[:val], activated_at: Time.now)
        render json: {success: true, message: '農場編號 '+@company.id.to_s+' 改為營運'}    
      else
        @company.update_columns(activated_c: params[:val])
        @company.products.each do |p|
          p.update_columns(available_c: false)
        end
        render json: {success: true, message: '農場編號 '+@company.id.to_s+' 改為非營運'}          
      end  
    when 'bank_code'
      @company.update_columns(bank_code: params[:val])
      render json: {success: true, message: '已更改農場編號 '+@company.id.to_s+' 的銀行代碼'}      
    when 'bank_account'   
      @company.update_columns(bank_account: params[:val])    
      render json: {success: true, message: '已更改農場編號 '+@company.id.to_s+' 的匯款帳號'}          
    when 'priority'  
      @company.update_columns(priority: params[:val])  
      render json: {success: true, message: '農場編號 '+@company.id.to_s+' 排序已變更為'+@company.priority.to_s}      
    end   
  end 

#======================# product #======================#   
  def products
    @products = Product.all.paginate(page: params[:page], per_page: 60).order(priority: :desc)             
  end
  
  def setProduct    
    case params[:kind]
    when 'GAP'
      params[:val] = params[:val] == 'true' ? true : false  
      @product.update_columns(GAP_c: params[:val])
      if params[:val]
        render json: {success: true, message: '商品編號 '+@product.id.to_s+' 吉園圃已認證'}    
      else
        render json: {success: true, message: '商品編號 '+@product.id.to_s+' 吉園圃已停用'}          
      end  
    when 'TAP'
      params[:val] = params[:val] == 'true' ? true : false 
      @product.update_columns(TAP_c: params[:val]) 
      if params[:val]
        render json: {success: true, message: '商品編號 '+@product.id.to_s+' TAP已認證'}    
      else
        render json: {success: true, message: '商品編號 '+@product.id.to_s+' TAP已停用'}          
      end 
    when 'OTAP'
      params[:val] = params[:val] == 'true' ? true : false  
      @product.update_columns(OTAP_c: params[:val])
      if params[:val]
        render json: {success: true, message: '商品編號 '+@product.id.to_s+' OTAP已認證'}    
      else
        render json: {success: true, message: '商品編號 '+@product.id.to_s+' OTAP已停用'}          
      end 
    when 'UTAP'
      params[:val] = params[:val] == 'true' ? true : false 
      @product.update_columns(UTAP_c: params[:val]) 
      if params[:val]
        render json: {success: true, message: '商品編號 '+@product.id.to_s+' UTAP已認證'}    
      else
        render json: {success: true, message: '商品編號 '+@product.id.to_s+' UTAP已停用'}          
      end   
    when 'pesticide_qualified'
      params[:val] = params[:val] == 'true' ? true : false  
      @product.update_columns(pesticide_qualified_c: params[:val])
      if params[:val]
        render json: {success: true, message: '商品編號 '+@product.id.to_s+' 藥檢合格已認證'}    
      else
        render json: {success: true, message: '商品編號 '+@product.id.to_s+' 藥檢合格已停用'}          
      end  
    when 'pesticide_zero'
      params[:val] = params[:val] == 'true' ? true : false
      @product.update_columns(pesticide_zero_c: params[:val])  
      if params[:val]
        render json: {success: true, message: '商品編號 '+@product.id.to_s+' 農藥零檢出已認證'}    
      else
        render json: {success: true, message: '商品編號 '+@product.id.to_s+' 農藥零檢出已停用'}          
      end   
    when 'sweet_degree'  
      @product.update_columns(sweet_degree: params[:val])  
      render json: {success: true, message: '商品編號 '+@product.id.to_s+' 甜度已變更為'+@product.sweet_degree.to_s}                       
    when 'priority'  
      @product.update_columns(priority: params[:val])  
      render json: {success: true, message: '商品編號 '+@product.id.to_s+' 排序已變更為'+@product.priority.to_s}      
    when 'discount'
      @product.update_columns(discount: params[:val])  
      render json: {success: true, message: '商品編號 '+@product.id.to_s+' 折扣已變更為'+(@product.discount*100).to_s+'折'}          
    end   
  end          


#======================# user #======================#     
  def users
    @users = User.all.paginate(page: params[:page], per_page: 60).order('id DESC')     
  end  
  
  def blockUser
    params[:block] = params[:block] == 'true' ? true : false                  
    if params[:block]
      @user.update_columns(blocked_c: params[:block], blocked_at: Time.now)
      render json: {success: true, message: '使用者編號 '+@user.id.to_s+' 已停用'}    
    else
      @user.update_columns(blocked_c: params[:block])
      render json: {success: true, message: '使用者編號 '+@user.id.to_s+' 已啟用'}          
    end    
  end
  
  def confirmPhoneNo
    address = @user.addresses.first 
    if !address.phone_no.blank? and address.phone_no_confirmed_at.blank?
      address.phone_no_confirmed_at = Time.now  
      address.save!     
      # important !!!!!!!!!!!!!!!!
      if @user.coupons.where(kind: GLOBAL_VAR['COUPON_SIGN_UP']).first.blank?       
        coupon = Coupon.new
        coupon.user = @user
        coupon.kind = GLOBAL_VAR['COUPON_SIGN_UP']
        coupon.amount = 30
        coupon.original_amount = 30
        coupon.save!
        flash[:success] = @user.last_name+@user.first_name+' 已成功驗證, 並獲得30元回饋金' 
      else
        flash[:alert] = @user.last_name+@user.first_name+' 已驗證過'                          
      end 
    else
      flash[:alert] = @user.last_name+@user.first_name+' 沒填行動電話或已驗證通過'                                
    end      
    redirect_to controller: 'management', action: 'users'   
  end
  
private   
  
  def managementCheckUser
    unless current_user.email == 'bennylin77@gmail.com' or
           current_user.email == 'tony7066@yahoo.com.tw' or
           current_user.email == 'b97a01134@ntu.edu.tw' or
           current_user.email == 'kais900202@hotmail.com' or
           current_user.email == '96206024@nccu.edu.tw'
      flash["error"]="您沒有權限"
      redirect_to root_url         
    end  
  end
  
  def set_order
    @order = Order.find(params[:id])
  end  

  def set_company
    @company = Company.find(params[:id])
  end
  
  def set_user
    @user = User.find(params[:id])
  end  
  
  def set_product
    @product = Product.find(params[:id])
  end

  def set_bill
    @bill = Bill.find(params[:id])
  end        
  
end
