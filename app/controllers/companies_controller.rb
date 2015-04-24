class CompaniesController < ApplicationController
 
 
  before_action only: [:edit, :update, :destroy] { |c| c.CompanyCheckUser(params[:id])}  
  before_action :set_company, only: [:show, :edit, :update, :destroy]


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

  def companiesImageUpload
    
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
