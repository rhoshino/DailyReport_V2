
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


def select_date(date, options = {})
  field = options[:from]
  select date.strftime('%Y'), :from => "#{field}_1i" #year
  select date.strftime('%m'), :from => "#{field}_2i" #month
  select date.strftime('%d').to_i, :from => "#{field}_3i" #day
end