require 'rails_helper'

require 'reports_helper'
# Specs in this file have access to a helper object that includes
# the UsersHelper. For example:
#
# describe UsersHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe UsersHelper, :type => :helper do

  let(:user){FactoryGirl.create(:user)}

  before do
    sign_in user
  end

  describe "month_report_worktime_calculator" do

    before do
      # visit new_report_path

      # select_date(Date.today.prev_month, from: "report_reported_date")
      # select_time("8","50","report_work_start_time")
      # select_time("18","30","report_work_end_time")

      # fill_in "report_title", with:"This is Test Title"
      # fill_in "report_body_text",with:"Lorem ipsum"

      # check "report_public_flag"



    end


    #TODO: Add this RSPEC


  end



  pending "add some examples to (or delete) #{__FILE__}"
end
