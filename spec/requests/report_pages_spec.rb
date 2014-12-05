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

    describe "with valid information" do
      before do#モデルのバリデーションに沿う

        #報告日付 (Utility Function)
        select_date(Date.today, from: "report_reported_date")

        #題名
        fill_in "report_title", with:"This is Test Title"
        #本文
        fill_in "report_body_text",with:"Lorem ipsum"

        #公開フラグ
        check "report_public_flag"

        click_button "save report"
      end

      it{ is_expected.to have_content("#{Date.today}")}
      it{ is_expected.to have_content("This is Test Title")}
      it{ is_expected.to have_content('Lorem ipsum') }
      it{ is_expected.to have_content('true') }

      it{ is_expected.to have_link('Edit') }
      it{ is_expected.to have_link('home') }

    end# with valid information



  end#Report Create


end