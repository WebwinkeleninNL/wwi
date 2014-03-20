module Auth
  def login_as(merchant)
    visit '/login'
    within("#login") do
      fill_in 'Email', :with => merchant.email
      fill_in 'Password', :with => merchant.password
    end
    click_button 'Log In'

    Capybara.session_name = merchant.first_name
  end
end
World(Auth)
