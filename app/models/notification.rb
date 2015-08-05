class Notification < ActiveRecord::Base
  belongs_to :order
  belongs_to :user
  belongs_to :comment
  belongs_to :sub_comment  
  belongs_to :product
  belongs_to :invoice
end
