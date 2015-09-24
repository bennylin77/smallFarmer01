class ProductsController < ApplicationController
  layout "companies", only: [:index, :edit, :new, :create, :update, :preview, :available]  
  before_filter :authenticate_user!, except: [:show] 
  
  before_action only: [:edit, :update, :preview, :destroy, :productImagesUpload, :productImagesDelete, :available, :productCoverUpload, :productCoverDelete] { |c| c.ProductCheckUser(params[:id])}      
  before_action :set_product, only: [:show, :edit, :update, :preview, :destroy, :productImagesUpload, :productImagesDelete, :available, :productCoverUpload, :productCoverDelete]
  before_action :available?, only: [:show]
  before_action :delete?, only: [:show]  

  def index
    @products = current_user.companies.first.products.where(deleted_c: false)
  end

  def show
  end

  def new
    product = Product.new
    p_b= product.product_boxings.build() 
    p_b.product_pricings.build(quantity: 1)   
    p_b.product_pricings.build()       
    product.company = current_user.companies.first
    product.save!           
    url = Googl.shorten(Rails.configuration.smallfarmer01_host+'/products/'+product.id.to_s, "", Rails.configuration.google_API_key )         
    product.update_columns(short_URL: url.short_url)             
    redirect_to edit_product_path(product)
  end

  def edit
    @keywords = ''
    @product.keywords.each do |k|
      @keywords = @keywords + ','+k.content
    end
    @shipping_time_1 = @product.shipping_time & 1; @shipping_time_2 = params[:shipping_time_2]; @shipping_time_4 = params[:shipping_time_4];
    @shipping_time_8 = @product.shipping_time & 8; @shipping_time_16 = params[:shipping_time_16]; @shipping_time_32 = params[:shipping_time_32];
    @shipping_time_64 = params[:shipping_time_64]; 
    
  end

  def update
    @product.update(product_params)  
    @keywords = params[:keywords]     
    @product.shipping_time = params[:shipping_time_1].to_i | params[:shipping_time_2].to_i | params[:shipping_time_4].to_i |
                             params[:shipping_time_8].to_i | params[:shipping_time_16].to_i | params[:shipping_time_32].to_i |
                             params[:shipping_time_64].to_i     
    unless @product.errors.any?  
      @product.keywords.clear
      @keywords.split(",").each do |k|
        keyword = Keyword.where(content: k).first
        if keyword.blank?
          keyword = Keyword.new(content: k)              
        end
        @product.keywords<<keyword 
      end    
      @product.save!
      flash[:notice] ='成功更改商品資料'
      redirect_to products_url      
    else  
      render 'edit'
    end   
  end
 
  def preview
    if @product.update(product_params)
      redirect_to @product
    else
      render 'edit'
    end    
  end
  
  def destroy
    @product.update_attribute(:deleted_c, true)   
    @product.update_attribute(:deleted_at, Time.zone.now)     
    flash[:notice] ='成功刪除商品編號'+@product.id.to_s        
    redirect_to products_url
  end

  def productCoverUpload
    if @product.cover.blank?      
      @product.update_attribute(:cover, params[:product][:cover])
      render json: { initialPreview: [
                        "<img src='"+@product.cover.url+"' class='file-preview-image'>",
                     ],
                     initialPreviewConfig: [{
                        url: "/products/"+@product.id.to_s+"/productCoverDelete"
                     }]
                   }              
    else
      render json: { error: '只能上傳一張商品封面。如要更新封面，請先刪除舊的封面。' }      
    end  
  end
  
  def productCoverDelete
    if @product.update_attribute(:cover, nil)  
      render json: {success: '刪除成功'}     
    else
      render json: {error: '刪除失敗'}           
    end   
  end

  def productImagesUpload
    if @product.product_images.size < 8
      p_i = ProductImage.create(image: params[:product_image].first )
      p_i.product = @product
      p_i.save!  
      render json: { initialPreview: [
                        "<img src='"+p_i.image.url+"' class='file-preview-image'>",
                     ],
                     initialPreviewConfig: [{
                        url: "/products/"+@product.id.to_s+"/productImagesDelete", key: p_i.id
                     }]
                   }
    else
      render json: { error: '上傳超過8張照片' }
    end                                 
  end

  def productImagesDelete 
    if @product.product_images.where(id: params[:key]).first.destroy   
      render json: {success: '刪除成功'}     
    else
      render json: {error: '刪除失敗'}           
    end    
  end 

  def available
    if @product.available_c
      @product.available_c = false
      @product.save!    
      flash[:alert] ='商品已下架'        
      redirect_to products_url      
    else  
      @company = current_user.companies.first
      @company.valid?(false) 
      unless @company.errors.any?
        @product.update(available_c: true, available_at: Time.zone.now)
        unless @product.errors.any?
          flash[:success] ='成功上架商品'        
          redirect_to products_url
        else
          render 'edit'
        end  
      else
        render 'companies/edit'  
      end        
    end 
  end
  
  
  private
  
    def available?
      unless @product.available_c or @product.company.user == current_user
        flash[:warning] = '商品還未上架'
        redirect_to root_url 
      end
    end
    
    def delete?
      if @product.deleted_c 
        flash[:warning] = '商品已刪除'
        redirect_to root_url 
      end
    end    
  
    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:name, :description, :inventory, :unit, :preservation, :released_at, :cold_chain, product_boxings_attributes:[:id, :quantity, :size, product_pricings_attributes:[:id, :quantity, :price]] )
    end
end
