class Cart < ActiveRecord::Base
  belongs_to :user
  belongs_to :product_boxing
end
