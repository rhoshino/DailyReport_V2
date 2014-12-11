#coding:utf-8
require 'rails_helper'

describe "Authentication" do

  subject {page}

  describe "authrization" do

    describe "for non-signed-in users" do
      let(:user){FactoryGirl.create(:user)}

      #non-signed-in  user id not have links
      it{ is_expected.not_to have_link('Home') }
      it{ is_expected.not_to have_link('Account') }
      it{ is_expected.not_to have_link('Profile') }
      it{ is_expected.not_to have_link('Settings') }
      it{ is_expected.not_to have_link('Sign out') }
      it{ is_expected.not_to have_link('日報') }
      it{ is_expected.not_to have_link('作成') }
      it{ is_expected.not_to have_link('一覧') }
      it{ is_expected.not_to have_link('月報') }
    end

    describe "Auth" do

      let(:admin){FactoryGirl.create(:user,role: 'admin')}
      let(:non_admin){FactoryGirl.create(:user)}
      let(:user){FactoryGirl.create(:user)}

      let(:user_report){FactoryGirl.create(:report, user: user,
                                          public_flag: true)}
      let(:non_admin_report){FactoryGirl.create(:report, user: non_admin,
                                          public_flag: true)}

      describe "Admin User" do
        before do
          sign_in admin
        end

        describe "AllReportPage" do
          before {visit admin_reports_list_path}

          it{ is_expected.to have_content("全ての日報一覧") }

        end#all report page

        describe "AllUserPage" do
          before {visit admin_users_list_path}

          it{ is_expected.to have_content("ユーザーリスト") }

        end# all user page

        describe "Admin is Show other user" do
          before {visit user_path(user)}
          it{ is_expected.to have_content("#{user.name}") }
        end

      end# Admin user


      describe "not Admin user" do
        before do
          sign_in non_admin
        end

        describe "AllReportPage" do
          before {visit admin_reports_list_path}

          it{ is_expected.not_to have_content("全ての日報一覧") }
          it{ is_expected.to have_content("あなたの日報")}
        end#all report page

        describe "AllUserPage" do
          before {visit admin_users_list_path}

          it{ is_expected.not_to have_content("ユーザーリスト") }
          it{ is_expected.to have_content("あなたの日報")}

        end# all user page

        describe "can show user page" do
          before {visit user_path(non_admin)}

          it{ is_expected.to have_content("#{non_admin.name}")}
          it{ is_expected.not_to have_content("あなたの日報")}
        end# show user page
        describe "can't show ather user page" do
          before {visit user_path(user)}

          it{ is_expected.not_to have_content("#{user.name}")}
          it{ is_expected.to have_content("あなたの日報")}
        end# can't show other user page

        describe "can own report page" do
          before{visit report_path(non_admin_report)}
          it{ is_expected.to have_content("#{non_admin.name}")}
          it{ is_expected.not_to have_content("あなたの日報")}
        end

        describe "can't other's report page" do
          before{visit report_path(user_report)}
          it{ is_expected.not_to have_content("#{user.name}")}
          it{ is_expected.to have_content("あなたの日報")}
        end

      end# not Admin user

    end#Admin


  end# auth
  pending "add some examples to (or delete) #{__FILE__}"
end