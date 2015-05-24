class Order < ActiveRecord::Base
  
  belongs_to :product_boxing
  belongs_to :invoice

end
