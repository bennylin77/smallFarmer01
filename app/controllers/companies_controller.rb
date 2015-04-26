class CompaniesController < ApplicationController
 
 
  before_action only: [:edit, :update, :destroy, :companyImagesUpload, :companyImagesDelete] { |c| c.CompanyCheckUser(params[:id])}  
  before_action :set_company, only: [:show, :edit, :update, :destroy, :companyImagesUpload, :companyImagesDelete]


  def show
  end

  def edit
  end

  def update
    if @company.update(company_params)
      flash[:notice] ='成功更改農場資料'
      redirect_to edit_company_path
    else
      redirect_to edit_company_path
    end    
  end

  def companyImagesUpload
    c_i = CompanyImage.create(image: params[:test].first )
    c_i.company = @company
    c_i.save!  
    render json: { initialPreview: [
                      "<img src='"+c_i.image.url+"' class='file-preview-image'>",
                   ],
                   initialPreviewConfig: [{
                      url: "/companies/"+@company.id.to_s+"/companyImagesDelete", key: c_i.id
                   }]
                 }              
  end

  def companyImagesDelete 
    if @company.company_images.where(id: params[:key]).first.destroy   
      render json: {success: '刪除成功'}     
    else
      render json: {error: '刪除失敗'}           
    end    
  end  

  def destroy
    @company.destroy
  end

  private
    def set_company
      @company = Company.find(params[:id])
    end

    def company_params
      params[:company][:phone_no] = params[:phone_no_full]      
      params.require(:company).permit(:cover, :name, :description, :user_id, :phone_no, :postal, :county, :district, :address)
    end
end
