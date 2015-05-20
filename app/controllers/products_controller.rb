class ProductsController < ApplicationController
  layout "companies", only: [:index, :edit]  
  before_filter :authenticate_user!, except: [:show] 
  
  before_action only: [:edit, :update, :destroy, :productImagesUpload, :productImagesDelete] { |c| c.ProductCheckUser(params[:id])}    
  before_action :set_product, only: [:show, :edit, :update, :destroy, :productImagesUpload, :productImagesDelete, :available]

  def index
    @products = current_user.companies.first.products
  end

  def show

  end

  def new
    product = Product.new
    product.company = current_user.companies.first
    product.save!
    product.product_boxings.create 
    product.product_boxings.first.product_pricings.create(quantity: 1)   
    product.product_boxings.first.product_pricings.create()       
    redirect_to edit_product_path(product)
  end

  def edit
  end

  def update
    if @product.update(product_params)
      flash[:notice] ='成功更改水果資料'
      redirect_to products_url
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
      params.require(:product).permit(:name, :description, :inventory, :unit, :preservation, product_boxings_attributes:[:id, :quantity, product_pricings_attributes:[:id, :quantity, :price]] )
    end
end
