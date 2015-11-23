class ProductBoxing < ActiveRecord::Base
  belongs_to :product
  has_many   :product_pricings, dependent: :destroy     
  has_many   :carts, dependent: :destroy     
  has_many   :orders  
    
  accepts_nested_attributes_for :product_pricings  
  #validates :quantity, presence: { presence: true, message: '請填寫 包裝種類_內含數量' }, on: :update 
  #validates :size, presence: { presence: true, message: '請填寫 包裝種類_箱子尺寸' }, on: :update 
  
  #validates_associated :product_pricings, message: '填寫格式錯誤或不能為空'   
  #validate  :associatedProductPricings  
=begin  
  def associatedProductPricings  
    product_pricings.each do |product_pricing|
      unless product_pricing.valid?
        product_pricing.errors.messages.each do |index, value|
          errors.add(index, value.first)
        end
      end 
    end
  end  
=end   
end
