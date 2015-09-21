module Smallfarmer
  class BILL_API < Grape::API
    version 'v1', using: :path
    format :json    
    prefix :bill_api   
    helpers Smallfarmer::ApplicationHelpers
    
    before do
      error!("授權失敗", 401) unless authenticated
    end
    
    desc "Return Bills"      
    post :index do
      { bills: current_user.companies.first.bills.order('id desc') }              
    end

    desc "Show bill"
    params do
      requires :bill_id, type: Integer, desc: "Bill id"
    end       
    post :show do
      bill = Bill.find(params[:bill_id])     
      if bill.company.user == current_user 
        orders = []
        bill.orders.each do |o|
          orders << o
        end
        { bill: bill, orders: orders }   
      else
        error!('您沒有權限', 401)          
      end
    end
      
  end
end 