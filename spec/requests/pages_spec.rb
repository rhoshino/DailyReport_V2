#coding:utf-8
describe "Pages" do

  subject{ page }

  shared_examples_for "all pages"do
    it{is_expected.to have_content(heading)}
  end

  describe "Home page" do
    before{visit root_path}
    let(:heading){'日報アプリケーション'}

    it_should_behave_like("all pages")

    describe "for Signed-in users" do
      let(:user){FactoryGirl.create(:user)}

      before do
        sign_in  user
        visit root_path
      end

      it{is_expected.to have_link('Home')}
      it{is_expected.to have_link('Account')}
      it{is_expected.to have_link('Profile')}
      it{is_expected.to have_link('Settings')}
      it{is_expected.to have_link('Sign out')}

      it{is_expected.to have_link('日報')}
      it{is_expected.to have_link('作成')}
      it{is_expected.to have_link('一覧')}

      it{is_expected.to have_link('月報')}

      it "try to Sign out" do
        click_link('Sign out')
        is_expected.to have_content("Sign in")
      end

    end#for Signed-in users
  end# Home page

  describe "Sign up Page" do

    before{ visit new_user_registration_path }

    it{is_expected.to have_content('Sign up')}
  end# Sign up page

  describe "Sign up Session" do
    before {visit new_user_registration_path}

    let(:submit){"Create Account"}

    describe "with Invalid information" do
      describe "after submission" do
        before{click_button submit}

        it{ is_expected.to have_content('Sign up')}
        it{ is_expected.to have_content("error")}
      end
    end#with Invalid information

    describe "with Valid information" do

      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "password"
        fill_in "Password confirmation", with: "password"
      end

      describe "after saving the user" do
        before{click_button submit}

        it {is_expected.to have_link('Sign out')}
        it {is_expected.to have_selector('div.alert.alert-notice', text:'Welcome!')}

        it "and redirect root, vanish flash massage" do
          visit root_path
          is_expected.not_to have_selector('div.alert.alert-notice', text:'Welcome!')
        end

      end# after saving the user

    end# with Valid information
  end#Sign up Session

  describe "show page" do
    let (:user){FactoryGirl.create(:user)}
    before do
      sign_in user
      visit user_path(user)
    end
    it{ is_expected.to have_content(user.name) }
    it{ is_expected.to have_content(user.email) }

  end

  describe "Edit User page" do
    let (:user){FactoryGirl.create(:user)}
    before do
      sign_in user
      visit edit_user_registration_path(user)
    end

    describe "page" do
      it{is_expected.to have_content("Edit User")}
    end

    describe "with valid information" do
      let(:new_name){"New Name"}
      let(:new_email){"new@example.com"}

      before do
        fill_in "Name",                  with: new_name
        fill_in "Email",                 with: new_email
        fill_in "Password",              with: user.password
        fill_in "Password confirmation", with: user.password
        click_button "Update"
      end

      it{is_expected.to have_content(new_name)}
      it{is_expected.to have_selector('div.alert.alert-notice', text:'success')}
      it{is_expected.to have_link('Sign out')}

      specify { expect(user.reload.name).to eq new_name }
      specify { expect(user.reload.email).to eq new_email }
    end# with Valid information

    describe "Address Check" do

      describe "One collect address" do
        before do

          fill_in 'user_temp_address', with:"hoge@null.com"
          click_button "Update"
        end
        it {is_expected.to have_content('Your account has been updated successfully.')}
        it {is_expected.to have_content('あなたの日報')}
      end

      describe "Sum collect address" do
        before do
          fill_in "user_temp_address",
                  with:"aafasfas@non.com\n" + "hoge@null.com"
          click_button "Update"
        end
        it {is_expected.to have_content('Your account has been updated successfully.')}
        it {is_expected.to have_content('あなたの日報')}
      end

      describe "One iriegal address" do
        before do
          fill_in "user_temp_address",
                  with:"damedesu"
          click_button "Update"
        end
        it {is_expected.not_to have_content('Your account has been updated successfully.')}
        it {is_expected.to have_content('error')}
      end
      describe "Sum One iriegal address" do
        before do
          fill_in "user_temp_address",
                  with: "aafasfas@non.com\n" + "damedesu"
          click_button "Update"
        end
        it {is_expected.not_to have_content('Your account has been updated successfully.')}
        it {is_expected.to have_content('error')}
      end
    end#adress check

  end# Edit user page

  describe "month Report" do
    let(:user){FactoryGirl.create(:user)}

    before do
      sign_in user
      visit month_report_path
      FactoryGirl.create(:report, user: user,
                           reported_date: "2015-12-25",
                           public_flag: true)
      FactoryGirl.create(:report, user: user,
                           reported_date: "2013-09-25",
                           public_flag: true)
    end

    describe "fill in year" do

      before do

        fill_in("year", with: "2013")
        fill_in("month", with: "09")
        # binding.pry
        click_button("更新")
      end

      it{is_expected.to have_content("2013-09-25")}
      it{is_expected.not_to have_content("2014-12-25")}
      it{is_expected.not_to have_content("2015-12-25")}
      it{is_expected.not_to have_content("日報がありません")}
    end# fill in year

    describe "Calc_time" do
      before do
        create_sum_report
        visit month_report_path
      end
      it {
        is_expected.to have_content("今月の労働時間(10時間40分)") }

      describe "fillterd_time" do
        before do
          visit month_report_path
          fill_in("year", with: "#{Date.today.prev_month.year}")
          fill_in("month", with: "#{Date.today.prev_month.month}")
          click_button("更新")
        end
        it{ is_expected.to have_content("表示月の労働時間(9時間0分)") }
      end

    end



  end# month Report

  describe "All User page" do
    let(:admin){FactoryGirl.create(:user,role: 'admin')}

    before do
      5.times{FactoryGirl.create(:user)}

      sign_in admin
      visit admin_users_list_path
    end

    describe "All user page shoud have All user's Name" do
      User.all.each do |user|
        it{is_expected.to have_content("#{user.name}")}
      end
    end

    describe "Admin is able to" do
      it "Delete User" do
        expect do
          click_link('delete',match: :first)
        end.to change(User, :count).by(-1)
      end
    end
  end# All User page

  describe "All Report page" do
    let(:admin){FactoryGirl.create(:user,role: 'admin')}
    let(:user){FactoryGirl.create(:user)}
    let(:other_user){FactoryGirl.create(:user)}

    before(:each) do
      sign_in admin
      visit admin_reports_list_path
      10.times {FactoryGirl.create(:report ,user: user)}
      10.times {FactoryGirl.create(:report ,user: other_user)}
    end

    describe "have content" do
      reports = Report.all
      reports.each do |report|
        is_expected.to have_content("#{report.id}")
        is_expected.to have_content("#{report.user.name}")
      end
    end

    describe "fill in User id" do

      before do
        fill_in("user", with: user.id)
        click_button("更新")
      end

      it "user's report is exist, and not other's report" do
        user.reports.each do |report|
          is_expected.to have_content("#{report.user.name}")
        end
        other_user.reports.each do |report|
          is_expected.not_to have_content("#{report.user.name}")
        end
      end
    end# fill in user id

    describe "fill in year" do

      before do
        FactoryGirl.create(:report, user: user,
                           reported_date: "2015-12-25")
        FactoryGirl.create(:report, user: user,
                           reported_date: "2013-12-25")
        fill_in("year", with: "2013")
        click_button("更新")
      end

      it{is_expected.to have_content("2013-12-25")}
      it{is_expected.not_to have_content("2014-12-25")}
      it{is_expected.not_to have_content("2015-12-25")}
      it{is_expected.not_to have_content("日報がありません")}
    end# fill in year

    describe "fill in month" do

      before do
        FactoryGirl.create(:report, user: user,
                           reported_date: "2015-09-25")
        FactoryGirl.create(:report, user: user,
                           reported_date: "2013-08-25")
        fill_in("month", with: "9")
        click_button("更新")
      end

      it{is_expected.to have_content("2015-09-25")}
      it{is_expected.not_to have_content("2014-12-25")}
      it{is_expected.not_to have_content("2013-08-25")}
      it{is_expected.not_to have_content("日報がありません")}
    end# fill in month

    describe "fill in public_flag" do
      before do
        FactoryGirl.create(:report, user: user,
                         title:"this is draft report",
                         public_flag: false )
        FactoryGirl.create(:report, user: user,
                         title:"this is public report",
                         public_flag: true )
        check  "public_flag"
        click_button("更新")
      end

      it{ is_expected.not_to have_content("this is draft report") }
      it{ is_expected.to have_content("this is public report") }
    end# fill in month

    describe "fill in serch_text" do

      before do
        FactoryGirl.create(:report, user: user,
                         title:"HAHAHA",
                         body_text: "myonmyonmyo myonmyo",
                         public_flag: true )
        FactoryGirl.create(:report, user: user,
                         title:"this is draft report",
                         public_flag: true )

        fill_in("serch_text", with:"myon")
        click_button("更新")
      end

      it{ is_expected.not_to have_content("this is draft report") }
      it{ is_expected.to have_content("HAHAHA") }
    end# fill in month

  end# All Report Page

end


private
  #HHACK: need refactorring
  def create_sum_report
        work_start_time = { :hour => "08", :minute => "20" }
        work_end_time = { :hour => "18", :minute => "20" }

        fill_data = { :reported_date => Date.today}

        fill_data[:work_start_time] = work_start_time
        fill_data[:work_end_time] = work_end_time
        # binding.pry
        fill_data[:title] = "This is Test Title"
        fill_data[:body_text] = "Lorem ipsum"
        fill_data[:public_flag] = true

        create_report_by_capybara(fill_data)

        work_start_time = { :hour => "09", :minute => "10" }
        work_end_time = { :hour => "09", :minute => "50" }

        fill_data = { :reported_date => Date.today}

        fill_data[:work_start_time] = work_start_time
        fill_data[:work_end_time] = work_end_time
        # binding.pry
        fill_data[:title] = "This is Test Title"
        fill_data[:body_text] = "Lorem ipsum"
        fill_data[:public_flag] = true

        create_report_by_capybara(fill_data)


        work_start_time = { :hour => "09", :minute => "00" }
        work_end_time = { :hour => "18", :minute => "00" }

        fill_data = { :reported_date => Date.today.prev_month}

        fill_data[:work_start_time] = work_start_time
        fill_data[:work_end_time] = work_end_time
        # binding.pry
        fill_data[:title] = "This is Test Title"
        fill_data[:body_text] = "Lorem ipsum"
        fill_data[:public_flag] = true

        create_report_by_capybara(fill_data)
  end