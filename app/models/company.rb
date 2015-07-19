class Company < ActiveRecord::Base
  belongs_to :user
  has_many   :company_images, dependent: :destroy   
  has_many   :products, dependent: :destroy   

  has_attached_file :cover, 
                    styles: { medium: "1024x1024>" },
                    default_url: "/images/:style/missing.png"  
  validates_attachment :cover, 
                       content_type: { content_type: /\Aimage\/.*\Z/, message: "圖片格式錯誤" }, 
                       size: { less_than: 10.megabytes, message: "圖片大小超過10MB" }  
                       
  validates :name, presence: { presence: true, message: '請填寫 農場名稱' }, on: :update                       
  validates :description, presence: { presence: true, message: '請填寫 農場介紹' }, on: :update                       
  validates :words, presence: { presence: true, message: '請填寫 農夫的話' }, on: :update                       
  validates :phone_no, presence: { presence: true, message: '請填寫 聯絡電話' }, on: :update                       
  validates :postal, presence: { presence: true, message: '請填寫 聯絡地址-郵遞區號' }, on: :update  
  validates :county, presence: { presence: true, message: '請填寫 聯絡地址-縣市' }, on: :update  
  validates :district, presence: { presence: true, message: '請填寫 聯絡地址-鄉鎮市區' }, on: :update  
  validates :address, presence: { presence: true, message: '請填寫 聯絡地址-詳細地址' }, on: :update 
  
  validates :words, length: { maximum: 140, message: '農夫的話 最多140個字' }, on: :update                              


                       
end
