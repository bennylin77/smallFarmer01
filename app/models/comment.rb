class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :product
  has_many   :sub_comments, dependent: :destroy   
  
end
