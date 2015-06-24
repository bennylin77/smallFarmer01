class ManagementController < ApplicationController
  
  
  def index
    
  end
  
  def invoices 
  end
  
  def orders
    params[:called_smallfarmer_c] = params[:called_smallfarmer_c] == 'true' ? true : false    
    @orders = Order.joins(product_boxing: {product: :company}, invoice: {} ).where('companies.id = ? and called_smallfarmer_c = ? and invoices.confirmed_c = 1', current_user.companies.first, params[:called_smallfarmer_c] ).all.paginate(page: params[:page], per_page: 30).order('id DESC')    
  end
  
end
