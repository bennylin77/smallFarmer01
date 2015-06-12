class Product < ActiveRecord::Base
  belongs_to :company
  has_many   :product_images, dependent: :destroy   
  has_many   :product_boxings, dependent: :destroy     
  has_many   :comments, dependent: :destroy   
    
  accepts_nested_attributes_for :product_boxings  
  
  validates :name, presence: { presence: true, message: '請填寫 水果名稱' }
  validates :description, presence: { presence: true, message: '請填寫 水果介紹' } 
  validates :unit, presence: { presence: true, message: '請填寫 單位' }   
  validates :inventory, presence: { presence: true, message: '請填寫 水果總庫存量' } 
  validates :daily_capacity, presence: { presence: true, message: '請填寫 水果日處理量' } 
  
end
