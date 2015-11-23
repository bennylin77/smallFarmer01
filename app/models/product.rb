class Product < ActiveRecord::Base
  belongs_to :company
  has_many   :product_images, dependent: :destroy   
  has_many   :product_boxings, dependent: :destroy     
  has_many   :comments, dependent: :destroy   
  has_many   :keyword_product_lists   
  has_many   :keywords, through: :keyword_product_lists 

  has_attached_file :cover, 
                    styles: { original: "1024", medium: "500"},
                    default_url: ':placeholder'               
  validates_attachment :cover, 
                       content_type: { content_type: /\Aimage\/.*\Z/, message: "圖片格式錯誤" }, 
                       size: { less_than: 10.megabytes, message: "圖片大小超過10MB" }  

    
  accepts_nested_attributes_for :product_boxings  

  validates :cover, presence: { presence: true, message: '請上傳 商品封面' }, on: :update                           
  validates :name, presence: { presence: true, message: '請填寫 名稱' }, on: :update
  validates :description, presence: { presence: true, message: '請填寫 介紹' }, on: :update 
  validates :unit, presence: { presence: true, message: '請填寫 單位' }, on: :update   
  validates :inventory, presence: { presence: true, message: '請填寫 本批數量' }, on: :update 
  validates :inventory, numericality: { less_than_or_equal_to: 999999, message: '請填寫 本批數量格式錯誤' }, on: :update
  validates :released_at, presence: { presence: true, message: '請填寫 出貨日期' }, on: :update 
  validates :cold_chain, presence: { presence: true, message: '請填寫 運送方式' }, on: :update   
  validates :name, length: { maximum: 12, message: '名稱 最多12個字' }, on: :update                              
    
  #validates_associated :product_boxings, message: '填寫格式錯誤或不能為空'  
  #validate  :associatedProductBoxings  
  validate  :inventoryMoreThanUnpaid, on: :update 
  
#product_image   
  validate  :productImageMoreThan, on: :update   
#product_boxing   
  validate  :productBoxingPresence, on: :update 
#product_pricing
  validate  :quantityMostWithPrice, on: :update 
  validate  :moreThanOneMostWithLowerPrice, on: :update 
  validate  :onlyOneQuantityWithOne, on: :update 
  
  
  


  def inventoryMoreThanUnpaid
    if inventory 
      unpaid = Order.joins(product_boxing: {}, invoice: {} ).where('product_boxings.id = ? and invoices.confirmed_c = ? and invoices.allpay_expired_at > ? ', self.product_boxings.first.id, false, Time.zone.now ).sum(:quantity)
      if inventory <  unpaid
        errors.add(:inventory, "本批數量不能低於尚未付款量 "+unpaid.to_s+"箱")
      end  
    else
      errors.add(:inventory, "請填寫 本批數量")  
    end   
  end
#product_image   
  def productImageMoreThan
    if product_images.count < 4
      errors.add(:product_images, "請至少上傳4張商品照片")  
    end     
  end       
#product_boxing   
  def productBoxingPresence
    product_boxings.each do |product_boxing| 
      unless product_boxing.deleted_c 
        if product_boxing.quantity.blank?
          errors.add('product_boxing', '請填寫 包裝種類_內含數量')          
        end     
        if product_boxing.size.blank?
          errors.add('product_size', '請填寫 包裝種類_箱子尺寸')          
        end  
      end       
    end
  end 
#product_pricing
  def quantityMostWithPrice
    product_boxings.each do |product_boxing| 
      unless product_boxing.deleted_c     
        product_boxing.product_pricings.each do |product_pricing|
          if product_pricing.quantity and product_pricing.price.blank?
            errors.add(:price, "請填寫 包裝種類_每箱賣")
          end   
          if product_pricing.quantity.blank? and product_pricing.price
            errors.add('product_pricings.quantity', "請填寫 包裝種類_促箱箱數")
          end      
        end  
      end  
    end  
  end 
  def moreThanOneMostWithLowerPrice
    product_boxings.each do |product_boxing| 
      unless product_boxing.deleted_c         
        one = product_boxing.product_pricings.where(quantity: 1).first 
        product_boxing.product_pricings.each do |product_pricing|
          if product_pricing.quantity 
            if product_pricing.quantity > 1
              if !one.price.blank? and !product_pricing.price.blank?
                if one.price < product_pricing.price
                  errors.add(:price, "包裝種類_'每箱'促銷價錢須小於等於原價")       
                end
              end
            end
          end          
        end     
      end
    end     
  end   
  def onlyOneQuantityWithOne
    product_boxings.each do |product_boxing| 
      unless product_boxing.deleted_c        
        one = product_boxing.product_pricings.where(quantity: 1).first   
        product_boxing.product_pricings.each do |product_pricing|      
          if one != product_pricing
            if product_pricing.quantity
              if product_pricing.quantity <= 1
                product_pricing.quantity = 0
                errors.add(:quantity, "促銷箱數需大於1箱")
              end
            end
          end   
        end
      end
    end      
  end
=begin   

  def associatedProductBoxings  
    product_boxings.each do |product_boxing|    
      unless product_boxing.valid?
        if !product_boxing.deleted_c 
          product_boxing.errors.messages.each do |index, value|
            errors.add(index, value.first)
          end
        end  
      end 
    end
  end   
=end   
end
