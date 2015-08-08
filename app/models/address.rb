class Address < ActiveRecord::Base
  belongs_to :user
  
  validates :last_name, presence: { presence: true, message: '請填寫 姓' }
  validates :first_name, presence: { presence: true, message: '請填寫 名' }
    
end
