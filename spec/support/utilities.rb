
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
def select_time(hour, minute, options = {})
  field = options[:from]
  #base_id = find(:xpath, ".//label[contains(.,'#{field}')]")[:for]
  # p "#{field}_4i"
  select hour, :from => "#{field}_4i"
  select minute, :from => "#{field}_5i"
end

def create_report_by_capybara(data)

  visit new_report_path

  #報告日付
  select_date(data[:reported_date], from: "report_reported_date")
  #出勤時間
  select_time(data[:work_start_time][:hour].to_s,
            data[:work_start_time][:minute].to_s,
            from:"report_work_start_time")
  #退勤時間
  select_time(data[:work_end_time][:hour].to_s,
              data[:work_end_time][:minute].to_s,
              from:"report_work_end_time")
  #題名
  fill_in "report_title", with:data[:title]
  #本文
  fill_in "report_body_text", with:data[:body_text]
  #公開/下書き
  check "report_public_flag" if(data[:public_flag]==true)

  click_button "save report"

end