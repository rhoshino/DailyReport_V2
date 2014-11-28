
def sign_in(user, options={})

  if options[:no_capybara]
    #TODO: pending code
  else
    visit new_user_session_path
    fill_in "Email",    with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
  end


end