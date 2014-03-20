Given(/^system has following merchants$/) do |merchants|
  @merchants = {}

  Role.find_or_create_by(name: Role::MERCHANT)
  Role.find_or_create_by(name: Role::ADMIN)

  merchants.hashes.each do |merchant|
    @merchants[merchant['name']] = FactoryGirl.create(:merchant, first_name: merchant['name'])
  end
end

Given(/^merchant '(.*)' create a product$/) do |merchant_name|
  @product = FactoryGirl.create(:product, user: @merchants[merchant_name])
end

When(/^another merchant '(.*)' login to Merchant system$/) do |merchant_name|
  login_as @merchants[merchant_name]
end

When(/^visit admin products page$/) do
  visit '/admin'
end

Then(/^see an empty list of products$/) do
  p page.body
  page.should have_selector('#admin_products')
  page.should_not have_content(@product.name)
end
