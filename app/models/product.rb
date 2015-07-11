class Product < ActiveRecord::Base
  belongs_to :company
  has_many   :product_images, dependent: :destroy   
  has_many   :product_boxings, dependent: :destroy     
  has_many   :comments, dependent: :destroy   
    
  accepts_nested_attributes_for :product_boxings  
  
  validates :name, presence: { presence: true, message: '請填寫 水果名稱' }, on: :update
  validates :description, presence: { presence: true, message: '請填寫 水果介紹' }, on: :update 
  validates :unit, presence: { presence: true, message: '請填寫 單位' }, on: :update   
  validates :inventory, presence: { presence: true, message: '請填寫 水果總庫存量' }, on: :update 
  validates :daily_capacity, presence: { presence: true, message: '請填寫 水果日處理量' }, on: :update 
  
end
