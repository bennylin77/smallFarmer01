class ProductBoxing < ActiveRecord::Base
  belongs_to :product
  has_many   :product_pricings, dependent: :destroy     
  has_many   :carts, dependent: :destroy     
  has_many   :orders  
    
  accepts_nested_attributes_for :product_pricings  
  validates :quantity, presence: { presence: true, message: '請填寫 每箱數量' } ,on: :update  

end
