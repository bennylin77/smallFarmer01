module Smallfarmer
  class ORDER_API < Grape::API
    version 'v1', using: :path
    format :json    
    prefix :order_api   
    helpers Smallfarmer::ApplicationHelpers
    
    before do
      error!("授權失敗", 401) unless authenticated
    end
    
    desc "Return Orders"      
    post :index do
      params[:called_smallfarmer_c] = params[:called_smallfarmer_c] == 'true' ? true : false    
      orders = []
      Order.joins(product_boxing: {product: :company}, invoice: {} ).where('companies.id = ? and called_smallfarmer_c = ? and invoices.confirmed_c = 1', current_user.companies.first, params[:called_smallfarmer_c] ).all.order('id').each do |o|         
        shipments = []
        o.shipments.each do |s|
          shipments << {shipment: s, receiver_address: s.receiver_address }
        end    
        orders << {
          order: o,
          product_boxing: o.product_boxing,
          product: o.product_boxing.product,
          product_cover: Rails.configuration.smallfarmer01_host+o.product_boxing.product.cover.url,  
          shipments: shipments
        }
      end   
      { orders: orders }              
    end

    desc "Confirm order"
    params do
      requires :order_id, type: Integer, desc: "Order id"
    end       
    post :confirm do
      order = Order.find(params[:order_id])     
      if order.product_boxing.product.company.user == current_user 
        if !order.called_smallfarmer_c
          order.called_smallfarmer_c = true
          order.called_smallfarmer_at = Time.zone.now
          order.shipments.each do  |s|
            s.status = GLOBAL_VAR['ORDER_STATUS_CONFIRMED']   
            s.save!
          end  
          order.save!
          notficationRead( { user_id: current_user.id, category: GLOBAL_VAR['NOTIFICATION_PRODUCT'], sub_category: GLOBAL_VAR['NOTIFICATION_SUB_NEW_ORDER'], order_id: order.id })
        end      
        { called_smallfarmer_at: order.called_smallfarmer_at }   
      else
        error!('您沒有權限', 401)          
      end
    end
      
  end
end 