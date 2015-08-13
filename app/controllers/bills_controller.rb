class BillsController < ApplicationController
  layout "companies", only: [:index]  
  before_action :set_bill, only: [:index]
  
  def index
    if params[:id].blank?
      
    end
      
  end
  
  private
    def set_bill
      @bill = Bill.find(params[:id])
    end  
end
