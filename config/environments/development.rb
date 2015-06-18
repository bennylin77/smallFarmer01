Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  config.allpay_check_out_url = 'http://payment-stage.allpay.com.tw/Cashier/AioCheckOut'
  config.allpay_merchant_id = '2000132'
  config.allpay_hash_key    = '5294y06JbISpM5x9'
  config.allpay_hash_iv     = 'v77hoKGq4kWxNNIS'
  config.allpay_return_url = 'http://smallfarmer01.com/invoices/allpayCreditNotify'  
     
  config.smallfarmer01_host = 'http://smallfarmer01.com'
      
  config.mitake_sm_send_get_url = 'http://smexpress.mitake.com.tw:9600/SmSendGet.asp'
  config.mitake_username = '24967500'
  config.mitake_password = 'dsf2rrgjn36kriithjb23wer'



  # General Settings
  config.app_domain = 'smallfarmer01.com'

  # Email
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.default_url_options = { host: config.app_domain }
  config.action_mailer.smtp_settings = {
    address: 'smtp.gmail.com', 
    port: '587',
    enable_starttls_auto: true,
    user_name: 'bennylin77',
    password: '4300377@nctu',
    authentication: :plain,
  }
  
end
