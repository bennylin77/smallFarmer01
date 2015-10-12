class MainController < ApplicationController
  def index
  end
  
  def typeaheadSource
    result = []        
    case params[:kind]    
    when '0'
      params[:query] = params[:query].gsub(/^\#{1}/, '') 
      keywords = Keyword.where('content LIKE ? and available_c = ?', "%#{params[:query]}%", true).limit(5)
      keywords.each do |k|
        result<<{ id: k.id, content: k.content, size: k.products.size }
      end    
    when '1'   
      products = Product.where('name LIKE ?', "%#{params[:query]}%").limit(5)
      products.each do |p|
        result<<{ product_name: p.name, company_name: p.company.name}
      end       
    when '2'   
      companies = Company.where('name LIKE ?', "%#{params[:query]}%").limit(5)
      companies.each do |c|
        result<<{ name: c.name}
      end       
    end
    render json: result   
  end
  
  def tempIndex       
    if !Rpush::Gcm::App.find_by_name("android_app")
      app = Rpush::Gcm::App.new
      app.name = "android_app"
      app.auth_key = Rails.configuration.android_API_key
      app.connections = 1
      app.save!
    end
    
    
  end
  
  def privacyPolicy    
  end
  
  def returnPolicy    
  end
  
  def search
    @query = params[:query] 
    if params[:query] =~ /^\#{1}/    
      @keyword = Keyword.where('content = ?', params[:query]).first
      if @keyword
        @keyword.update_columns(search_count: @keyword.search_count+1)
      end
      @products = Product.joins(:keywords).where('keywords.content = ?', params[:query]).where(available_c: true, deleted_c: false)
    else
      @keyword = Keyword.where('content = ?', '#'+params[:query]).first
      if @keyword.blank?
        products  = Product.where('name LIKE ?', "%#{params[:query]}%").where( available_c: true, deleted_c: false) 
        companies = Company.where('name LIKE ?', "%#{params[:query]}%").where( activated_c: true) 
        @all = ( products + companies ).uniq.sort{|a,b| b.priority <=> a.priority }      
      else
        @products = Product.joins(:keywords).where('keywords.content = ?', '#'+params[:query]).where(available_c: true, deleted_c: false)       
      end  
    end
    
  end
    
  def farms  
    @companies = Company.all       
  end
  
  def fruits   
    @products = Product.all.where(available_c: true, deleted_c: false).order(priority: :desc)
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
