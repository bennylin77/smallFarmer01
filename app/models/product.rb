class Product < ActiveRecord::Base
  belongs_to :company
  has_many   :product_images, dependent: :destroy   
  has_many   :product_boxings, dependent: :destroy     
  has_many   :comments, dependent: :destroy   
    
  accepts_nested_attributes_for :product_boxings  
  
  validates :name, presence: { presence: true, message: '請填寫 水果名稱' } ,on: :update  
  validates :description, presence: { presence: true, message: '請填寫 水果介紹' } ,on: :update  
  
end
