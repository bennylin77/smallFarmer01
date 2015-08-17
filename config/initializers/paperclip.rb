Paperclip.interpolates(:placeholder) do |attachment, style|
  ActionController::Base.helpers.asset_path("default_#{style}.jpg")
end