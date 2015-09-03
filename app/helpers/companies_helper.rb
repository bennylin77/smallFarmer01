module CompaniesHelper
  def farmSumOfDeliciousAndTasty(farm) 
    sum = 0
    farm.products.each do |pp|
      sum = sum + pp.product_boxings.first.orders.where('review_at IS NOT NULL and review_score = ? ', GLOBAL_VAR['ORDER_REVIEW_DELICIOUS']).count + 
      pp.product_boxings.first.orders.where('review_at IS NOT NULL and review_score = ? ', GLOBAL_VAR['ORDER_REVIEW_TASTY']).count    
    end  
    sum  
  end  
end
