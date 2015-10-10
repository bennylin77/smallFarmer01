class Keyword < ActiveRecord::Base
  has_many  :keyword_product_lists, dependent: :destroy
  has_many  :products, through: :keyword_product_lists
    
  has_attached_file :cover, 
                    styles: { original: "1024", medium: "500"},
                    default_url: ActionController::Base.helpers.asset_path('default_company_cover.jpg')               
                    
  validates_attachment :cover, 
                       content_type: { content_type: /\Aimage\/.*\Z/, message: "圖片格式錯誤" }, 
                       size: { less_than: 10.megabytes, message: "圖片大小超過10MB" }    
  
end
