class Bill < ActiveRecord::Base
  belongs_to :company
  has_many :orders
  
  
  
  def begin_at_end_at; " #{begin_at.strftime("%Y-%m-%d")}~#{end_at.strftime("%Y-%m-%d")}";end   
  
end
