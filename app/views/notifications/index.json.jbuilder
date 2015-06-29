json.array!(@notifications) do |notification|
  json.extract! notification, :id, :category, :sub_category, :content, :order_id, :user_id, :comment_id, :product_id, :invoice_id
  json.url notification_url(notification, format: :json)
end
