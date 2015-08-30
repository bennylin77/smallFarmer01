class MainController < ApplicationController
  def index
  end
  
  def tempIndex    
  end
  
  def privacyPolicy    
  end
  
  def returnPolicy    
  end
  
  def search
    @products = Product.all
  end
    
  def farms  
    @companies = Company.all       
  end
  
  def fruits   
    @products = Product.all.where(deleted_c: false)  
  end
  
  def marketing   
  end
  
  def fb
    redirect_to 'https://www.facebook.com/smallfarmer01'
  end
  
  def under
    #render layout: 'temp'
  end
  
  def surveyFarmer
    render layout: false   
  end
  
  def getFruitsAndFarms
    
    result = Array.new
=begin    
    company = Company.where("name LIKE ?", "%#{params[:term]}%")
    company.each do |c|
      result << 
      {
        abc: 123
        #:label =>c.model+' '+c.title+' '+c.kind,
        #:value =>c.model
      }      
    end
=end

    
    result = {
    options: [
        "Option 1",
        "Option 2",
        "Option 3",
        "Option 4",
        "Option 5"
    ]
  }
    
    render json: result.to_json       
  end  
  
  def showCartsNotifications
    render json: { quantity: current_user.notifications.where(read_c: false).size + current_user.carts.sum(:quantity) }  
  end
  
end
