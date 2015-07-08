class ManagementController < ApplicationController
  
  before_action :set_order, only: []
  before_action :set_company, only: [:activateCompany]
  before_action :set_user, only: [:blockUser]
  
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
  
  def callLogistics
    params[:orders].each do |o|
      order = Order.find(o)
      order.called_logistics_c = true
      order.called_logistics_at = Time.now 
      order.status = GLOBAL_VAR['ORDER_STATUS_CALLED_LOGISTICS'] 
      order.save!
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
end
