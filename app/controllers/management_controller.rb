class ManagementController < ApplicationController
  
  before_action :set_order, only: []
  before_action :set_company, only: [:activateCompany]
  before_action :set_user, only: [:blockUser, :confirmPhoneNo]
  before_action :set_product, only: [:setCertification, :setSweetDegree]
  
  def index
    
  end
  
  def invoices 
    @invoices = Invoice.all.paginate(page: params[:page], per_page: 60).order('id DESC')     
  end
  
  def orders
    params[:called_smallfarmer_c] = params[:called_smallfarmer_c] == 'true' ? true : false    
    params[:called_logistics_c] = params[:called_logistics_c] == 'true' ? true : false    
      
    @orders = Order.joins(:invoice).where('called_smallfarmer_c = ? and called_logistics_c = ? and invoices.confirmed_c = 1', 
                                    params[:called_smallfarmer_c], params[:called_logistics_c]).all.paginate(page: params[:page], per_page: 60).order('id DESC')    
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
      #
      #if order.review_at.blank?
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
        end
      #end                
    end
    render json: {success: true}
  end  
   
  def companies
    params[:activated_c] = params[:activated_c] == 'true' ? true : false              
    @companies = Company.where('activated_c = ?', params[:activated_c]).all.paginate(page: params[:page], per_page: 60).order('id DESC')     
  end  
  
  def activateCompany
    params[:activate] = params[:activate] == 'true' ? true : false                  
    if params[:activate]
      @company.update_columns(activated_c: params[:activate], activated_at: Time.now)
      render json: {success: true, message: '農場編號 '+@company.id.to_s+' 改為營運'}    
    else
      @company.update_columns(activated_c: params[:activate])
      render json: {success: true, message: '農場編號 '+@company.id.to_s+' 改為非營運'}          
    end    
  end

  def products
    @products = Product.all.paginate(page: params[:page], per_page: 60).order('id DESC')             
  end
  
  def setCertification    
    params[:val] = params[:val] == 'true' ? true : false                      
    case params[:kind]
    when 'GAP'
      if params[:val]
        @product.update_columns(GAP_c: params[:val])
        render json: {success: true, message: '水果編號 '+@product.id.to_s+' 吉園圃已認證'}    
      else
        @product.update_columns(GAP_c: params[:val])
        render json: {success: true, message: '水果編號 '+@product.id.to_s+' 吉園圃已停用'}          
      end  
    when 'TAP'
      if params[:val]
        @product.update_columns(TAP_c: params[:val])
        render json: {success: true, message: '水果編號 '+@product.id.to_s+' TAP已認證'}    
      else
        @product.update_columns(TAP_c: params[:val])
        render json: {success: true, message: '水果編號 '+@product.id.to_s+' TAP已停用'}          
      end 
    when 'OTAP'
      if params[:val]
        @product.update_columns(OTAP_c: params[:val])
        render json: {success: true, message: '水果編號 '+@product.id.to_s+' OTAP已認證'}    
      else
        @product.update_columns(OTAP_c: params[:val])
        render json: {success: true, message: '水果編號 '+@product.id.to_s+' OTAP已停用'}          
      end 
    when 'UTAP'
      if params[:val]
        @product.update_columns(UTAP_c: params[:val])
        render json: {success: true, message: '水果編號 '+@product.id.to_s+' UTAP已認證'}    
      else
        @product.update_columns(UTAP_c: params[:val])
        render json: {success: true, message: '水果編號 '+@product.id.to_s+' UTAP已停用'}          
      end                   
    end   
  end  
        
  def setSweetDegree
    @product.update_columns(sweet_degree: params[:val])
    render json: {success: true, message: '水果編號 '+@product.id.to_s+' 甜度已變更為'+@product.sweet_degree.to_s}     
  end
  
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
  
end
