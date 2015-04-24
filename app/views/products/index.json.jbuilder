json.array!(@products) do |product|
  json.extract! product, :id, :name, :description, :inventory, :delete_c, :available_c, :company_id
  json.url product_url(product, format: :json)
end
