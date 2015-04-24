class CompanyImage < ActiveRecord::Base
  belongs_to :company
  
  has_attached_file :image, 
                    styles: { medium: "800x800>" },
                    default_url: "/images/:style/missing.png"  
  validates_attachment :image, 
                       content_type: { content_type: /\Aimage\/.*\Z/, message: "圖片格式錯誤" }, 
                       size: { less_than: 10.megabytes, message: "圖片大小超過10MB" }  
  
end
