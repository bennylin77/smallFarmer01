class BillsController < ApplicationController
  layout "companies", only: [:index]  
  
  def index
    current_user
  end
  
end
