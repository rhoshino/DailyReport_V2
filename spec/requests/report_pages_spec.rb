#coding:utf-8
'rails_helper'

describe "ReportPages" do

  subject { page }

  let(:user){FactoryGirl.create(:user)}
  before{sign_in user}

  describe "Report Creation" do
    #まず日報作成画面に入る
    before do
      visit root_path
      click_link "作成"
    end

    describe "page" do

      it{ is_expected.to have_content("日報作成") }
      it{ is_expected.to have_content("報告日付") }
      it{ is_expected.to have_content("出勤時間") }
      it{ is_expected.to have_content("退勤時間") }
      it{ is_expected.to have_content("題名") }
      it{ is_expected.to have_content("本文") }
      it{ is_expected.to have_content("公開フラグ") }
      it{ is_expected.to have_button("save report") }

    end

    describe "with valid information" do
      before do#モデルのバリデーションに沿う

        #報告日付 (Utility Function)
        # select_date(Date.today, from: "report_reported_date")

        # #出勤時間、退勤時間 (Utility Function)
        # select_time("08","30",from:"report_work_start_time")
        # select_time("19","50",from:"report_work_end_time")

        # #題名
        # fill_in "report_title", with:"This is Test Title"
        # #本文
        # fill_in "report_body_text",with:"Lorem ipsum"

        # #公開フラグ
        # check "report_public_flag"

        # click_button "save report"


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
      end

      it{ is_expected.to have_content("#{Date.today}")}
      it{ is_expected.to have_content("This is Test Title")}
      it{ is_expected.to have_content('Lorem ipsum') }
      it{ is_expected.to have_content('true') }
      it{ is_expected.to have_content('08:20')}
      it{ is_expected.to have_content('18:20')}

      it{ is_expected.to have_link('Edit') }
      it{ is_expected.to have_link('home') }

      describe "With Month Report" do
        before do
          visit month_report_path
          fill_in "year", with:"#{Date.today.year}"
          fill_in "month", with:"#{Date.today.month.to_i}"
          click_button "更新"
        end
        it{ is_expected.to have_content("#{Date.today}")}
        it{ is_expected.to have_content("This is Test Title")}
        it{ is_expected.to have_content('Lorem ipsu') }

        it{ is_expected.not_to have_content('Lorem ipsum') }

        describe "not show other month report" do
          before do
            FactoryGirl.create(:report,
                                user: user,
                                reported_date: "2014-11-13",
                                title: "other month",
                                body_text: "This is not December")
            click_button "更新"
          end
          it{ is_expected.not_to have_content("2014-11-13")}
          it{ is_expected.not_to have_content("other month")}
        end

      end

    end# with valid information

  end#Report Create
end