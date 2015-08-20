class ProductImage < ActiveRecord::Base
  belongs_to :product
 
  has_attached_file :image, 
                    styles: { medium: "800"},
                    default_url: "/images/:style/missing.png"  
  validates_attachment :image, 
                       content_type: { content_type: /\Aimage\/.*\Z/, message: "照片格式錯誤" }, 
                       size: { less_than: 10.megabytes, message: "照片大小超過10MB" }  
    
end
