class ReceiverAddress < ActiveRecord::Base
  has_many :shipments
  
  validates :last_name, presence: { presence: true, message: '請填寫 姓' }
  validates :first_name, presence: { presence: true, message: '請填寫 名' }  
  validates :phone_no, presence: { presence: true, message: '請填寫 聯絡電話' }                      
  validates :postal, presence: { presence: true, message: '請填寫 聯絡地址-郵遞區號' }  
  validates :county, presence: { presence: true, message: '請填寫 聯絡地址-縣市' } 
  validates :district, presence: { presence: true, message: '請填寫 聯絡地址-鄉鎮市區' }  
  validates :address, presence: { presence: true, message: '請填寫 聯絡地址-詳細地址' } 
end
