OmniKassa.config(
  secret_key:   '002020000000001_KEY1',
  merchant_id:  '002020000000001',
  customer_language: 'nl',
  key_version: 1,
  currency_code: 978, # Euro
  url: 'https://payment-webinit.simu.omnikassa.rabobank.nl/paymentServlet',
  transaction_reference: lambda {|order_id| "omnikassatest#{Time.now.to_i}" }
)