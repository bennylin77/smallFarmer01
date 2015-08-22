class Product < ActiveRecord::Base
  belongs_to :company
  has_many   :product_images, dependent: :destroy   
  has_many   :product_boxings, dependent: :destroy     
  has_many   :comments, dependent: :destroy   

  has_attached_file :cover, 
                    styles: { medium: "1024", small: "100" },
                    default_url: ':placeholder'               
  validates_attachment :cover, 
                       content_type: { content_type: /\Aimage\/.*\Z/, message: "圖片格式錯誤" }, 
                       size: { less_than: 10.megabytes, message: "圖片大小超過10MB" }  

    
  accepts_nested_attributes_for :product_boxings  
  
  validates :name, presence: { presence: true, message: '請填寫 名稱' }, on: :update
  validates :description, presence: { presence: true, message: '請填寫 介紹' }, on: :update 
  validates :unit, presence: { presence: true, message: '請填寫 單位' }, on: :update   
  validates :inventory, presence: { presence: true, message: '請填寫 總庫存量' }, on: :update 
  validates :daily_capacity, presence: { presence: true, message: '請填寫 每日可出貨量' }, on: :update 
  validates :cold_chain, presence: { presence: true, message: '請填寫 運送方式' }, on: :update   
  validates :name, length: { maximum: 10, message: '名稱 最多10個字' }, on: :update                              
    
  validates_associated :product_boxings, message: '填寫格式錯誤或不能為空'  
  
  validate  :inventoryMoreThanUnpaid, on: :update 
  validate  :productImageMoreThan, on: :update   
  validate  :associatedProductBoxings  

  def productImageMoreThan
    if product_images.count < 4
      errors.add(:product_images, "請至少上傳4張商品照片")  
    end     
  end 
     
  def inventoryMoreThanUnpaid
    if inventory 
      if inventory <  Order.joins(product_boxing: {}, invoice: {} ).where('product_boxings.id = ? and invoices.confirmed_c = ? and invoices.allpay_expired_at > ? ', self.product_boxings.first.id, false, Time.now ).sum(:quantity)
        errors.add(:inventory, "總庫存量不能低於尚未付款量")
      end  
    else
      errors.add(:inventory, "請填寫 總庫存量")  
    end   
  end
  
  def associatedProductBoxings  
    product_boxings.each do |product_boxing|
      unless product_boxing.valid?
        product_boxing.errors.messages.each do |index, value|
          errors.add(index, value.first)
        end
      end 
    end
  end   
   
end
