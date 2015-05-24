class Order < ActiveRecord::Base
  
  belongs_to :product_boxing
  
  validates :receiver_last_name, presence: { presence: true, message: '請填寫 收件人資訊-姓' } 
  validates :receiver_first_name, presence: { presence: true, message: '請填寫 收件人資訊-名' }
  validates :receiver_phone_no, presence: { presence: true, message: '請填寫 收件人資訊-聯絡電話' } 
  validates :receiver_postal, presence: { presence: true, message: '請填寫 收件人資訊-郵遞區號' } 
  validates :receiver_county, presence: { presence: true, message: '請填寫 收件人資訊-縣市' } 
  validates :receiver_district, presence: { presence: true, message: '請填寫 收件人資訊-鄉鎮市區' } 
  validates :receiver_address, presence: { presence: true, message: '請填寫 收件人資訊-詳細地址' }
    
end
