'rails_helper'

describe "ReportPages" do

  subject { page }

  let(:user){FactoryGirl.create(:user)}
  before{sign_in user}

  describe "Report Creation" do
    before do
      visit root_path
      click_link "作成"
    end




  end#Report Create


end