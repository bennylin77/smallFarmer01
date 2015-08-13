class Bill < ActiveRecord::Base
  belongs_to :company
  has_many :orders
end
