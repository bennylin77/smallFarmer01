class ManagementController < ApplicationController
  
  before_action :set_order, only: []
  
  def index
    
  end
  
  def invoices 
  end
  
  def orders
    params[:called_smallfarmer_c] = params[:called_smallfarmer_c] == 'true' ? true : false    
    params[:called_logistics_c] = params[:called_logistics_c] == 'true' ? true : false    
   
    @orders = Order.joins(product_boxing: {product: :company}, invoice: {} ).where('companies.id = ? and called_smallfarmer_c = ? and called_logistics_c = ? and invoices.confirmed_c = 1', 
                          current_user.companies.first, params[:called_smallfarmer_c], params[:called_logistics_c]).all.paginate(page: params[:page], per_page: 30).order('id DESC')    
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
  
  private   
    def set_order
      @order = Order.find(params[:id])
    end  
  
end
