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

    describe "CanCan" do
      let(:user_a) {FactoryGirl.create(:user,
                                        name: 'Stanly',
                                        email: 'Stanly@spec.com')}
      let(:user_b) {FactoryGirl.create(:user,
                                        name: 'Narrator',
                                        email: 'Narrator@spec.com')}

      let(:report_a){FactoryGirl.create(:report,user: user_a)}
      let(:report_b){FactoryGirl.create(:report,user: user_b)}

      describe "user_a is can'not edit user_b's Reporty" do
        before do
          # binding.pry
          sign_in user_a
          visit report_path(report_b.id)
        end
        it{save_and_open_page
          is_expected.not_to have_content(user_b.name)}


      end

    end


  end
  pending "add some examples to (or delete) #{__FILE__}"
end