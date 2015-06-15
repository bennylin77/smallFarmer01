class ProductsController < ApplicationController
  layout "companies", only: [:index, :edit, :new, :create, :update]  
  before_filter :authenticate_user!, except: [:show] 
  
  before_action only: [:edit, :update, :destroy, :productImagesUpload, :productImagesDelete] { |c| c.ProductCheckUser(params[:id])}    
  before_action :set_product, only: [:show, :edit, :update, :destroy, :productImagesUpload, :productImagesDelete, :available]

  def index
    @products = current_user.companies.first.products
  end

  def show

  end

  def new
    @product = Product.new
    p_b= @product.product_boxings.build() 
    p_b.product_pricings.build(quantity: 1)   
    p_b.product_pricings.build()       
    #redirect_to edit_product_path(product)
  end

  def create
    @product = Product.new(product_params)
    @product.company = current_user.companies.first
    if @product.save
      params[:product_image].each do |p|
        p_i = ProductImage.create(image: p )
        p_i.product = @product
        p_i.save!      
      end    
      flash[:notice]='成功新增水果'
      redirect_to products_url
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      flash[:notice] ='成功更改水果資料'
      render 'edit'
    else
      render 'edit'
    end   
  end

  def destroy
    @product.destroy
    redirect_to products_url
  end

  def productImagesUpload
    if @product.product_images.size < 5
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
      render json: { error: '上傳超過5張圖片' }
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
      flash[:alert] ='水果已下架'        
      redirect_to products_url      
    else  
      if @product.update(available_c: true)
        flash[:success] ='成功上架水果'        
        redirect_to products_url
      else
        render 'edit'
      end        
    end 
  end
  private
    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:name, :description, :inventory, :unit, :preservation, :daily_capacity, product_boxings_attributes:[:id, :quantity, product_pricings_attributes:[:id, :quantity, :price]] )
    end
end
