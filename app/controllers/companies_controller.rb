class CompaniesController < ApplicationController
  before_filter :authenticate_user!, except: [:show]   
 
  before_action only: [:edit, :update, :preview, :companyImagesUpload, :companyImagesDelete, :companyCoverUpload, :companyCoverDelete] { |c| c.CompanyCheckUser(params[:id])}  
  before_action :set_company, only: [:show, :edit, :update, :preview, :companyImagesUpload, :companyImagesDelete, :companyCoverUpload, :companyCoverDelete]


  def show
    render layout: 'application'     
  end

  def edit
  end

  def update
    if @company.update(company_params)
      flash[:notice] ='成功更改農場資料'
      redirect_to edit_company_path(@company)      
    else
      render 'edit'    
    end
  end

  def preview
    if @company.update(company_params)
      redirect_to @company
    else
      render 'edit'
    end      
  end

  def companyCoverUpload
    if @company.cover.blank?      
      @company.update_attribute(:cover, params[:company][:cover])
      render json: { initialPreview: [
                        "<img src='"+@company.cover.url+"' class='file-preview-image'>",
                     ],
                     initialPreviewConfig: [{
                        url: "/companies/"+@company.id.to_s+"/companyCoverDelete"
                     }]
                   }              
    else
      render json: { error: '只能上傳一張農場封面。如要更新封面，請先刪除舊的封面。' }      
    end  
  end
  
  def companyCoverDelete
    if @company.update_attribute(:cover, nil)  
      render json: {success: '刪除成功'}     
    else
      render json: {error: '刪除失敗'}           
    end   
  end
  
  def companyImagesUpload
    if @company.company_images.size < 5    
      c_i = CompanyImage.create(image: params[:company_image].first )
      c_i.company = @company
      c_i.save!  
      render json: { initialPreview: [
                        "<img src='"+c_i.image.url+"' class='file-preview-image'>",
                     ],
                     initialPreviewConfig: [{
                        url: "/companies/"+@company.id.to_s+"/companyImagesDelete", key: c_i.id
                     }]
                   }        
    else
      render json: { error: '上傳超過5張照片' }
    end                                 
  end

  def companyImagesDelete 
    if @company.company_images.where(id: params[:key]).first.destroy   
      render json: {success: '刪除成功'}     
    else
      render json: {error: '刪除失敗'}           
    end    
  end  

  private
    def set_company
      @company = Company.find(params[:id])
    end

    def company_params
      params[:company][:phone_no] = params[:phone_no_full]      
      params.require(:company).permit(:name, :description, :words, :user_id, :phone_no, :postal, :county, :district, :address)
    end
end
