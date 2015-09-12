class MainController < ApplicationController
  def index
  end
  
  def keywords
    result = []    
    keywords = Keyword.where('content LIKE ?', "%#{params[:query]}%")
    keywords.each do |k|
      result<<{ keyword: k.content, display: k.content+' (目前'+k.products.size.to_s+'項商品)' }
    end   
    keywords = Product.where('name LIKE ?', "%#{params[:query]}%")
    keywords.each do |k|
      result<<{ keyword: k.name, display: k.name}
    end      
    render json: result
  end
  
  def tempIndex    
  end
  
  def privacyPolicy    
  end
  
  def returnPolicy    
  end
  
  def search
    @products = Product.where('name LIKE ?', "%#{params[:query]}%").where(available_c: true, deleted_c: false) + Product.joins(:keywords).where('keywords.content LIKE ?', "%#{params[:query]}%").where(available_c: true, deleted_c: false)
    @products = @products.uniq.sort{|a,b| b.priority <=> a.priority }
    #@products = Product.joins( keyword_product_lists: :keyword ).where('keywords.content LIKE ? or name LIKE ?', "%#{params[:query]}%, ")    
    
    #@products = Product.joins(product_boxing: {product: :company}).where('companies.id = ? and called_smallfarmer_c = ? and invoices.confirmed_c = 1', current_user.companies.first, params[:called_smallfarmer_c] ).all.paginate(page: params[:page], per_page: 30).order('id')    
   

    @query = params[:query]
=begin    
    result = []
    keywords.each do |k|
      result<<{ keyword: k.content, display: k.content+' (目前'+k.products.size.to_s+'項商品)' }
    end   
    render json: result
=end        
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
