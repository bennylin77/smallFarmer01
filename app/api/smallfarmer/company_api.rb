module Smallfarmer
  class COMPANY_API < Grape::API
    version 'v1', using: :path
    format :json    
    prefix :company_api   
    helpers Smallfarmer::ApplicationHelpers
    
    before do
      error!("授權失敗", 401) unless authenticated
    end
    
    desc "Show company"
    params do
      requires :company_id, type: Integer, desc: "Company id"
    end        
    post :show do
      if params[:company_id] == current_user.companies.first.id
        company = current_user.companies.first
      else  
        company = Company.select("id, cover_file_name, cover_content_type, cover_file_size, cover_updated_at, user_id, deleted_c, activated_c, activated_at, postal, county, district, address, name, description, words, accept_the_terms_of_use_c, accept_the_terms_of_use_at").find(params[:company_id])
      end     
      { company: company, company_cover: Rails.configuration.smallfarmer01_host + company.cover.url }   
    end    
    
       
  end
end  