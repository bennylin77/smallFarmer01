class Keyword < ActiveRecord::Base
  has_many  :keyword_product_lists, dependent: :destroy
  has_many  :products, through: :keyword_product_lists
end
