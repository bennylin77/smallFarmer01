class BillsController < ApplicationController
  layout "companies", only: [:index]  
  
  before_action only: [:index] { |c| c.BillCheckUser(params[:id])}          
  before_action :set_bill, only: [:index]
  
  def index
  end
  
  private
    def set_bill
      @bill = Bill.find(params[:id])
    end  
end
