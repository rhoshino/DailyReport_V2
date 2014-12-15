require 'rails_helper'

RSpec.describe Report, :type => :model do

  let(:user){ FactoryGirl.create(:user) }

  before{@report = user.reports.build(title: "example title",
                                      body_text: "Lorem ipsum",
                                      reported_date: "2014-12-25",
                                      work_start_time: "09:00",
                                      work_end_time: "18:00",
                                      public_flag: true)}

  subject{ @report }

  it{is_expected.to respond_to(:title)}
  it{is_expected.to respond_to(:user_id)}
  it{is_expected.to respond_to(:user)}
  it{is_expected.to respond_to(:reported_date)}
  it{is_expected.to respond_to(:work_start_time)}
  it{is_expected.to respond_to(:work_end_time)}
  it{is_expected.to respond_to(:rest)}


  it {is_expected.to be_valid}


  describe "when user_id is not present" do
    before {@report.user_id = nil}
    it {is_expected.not_to be_valid}
  end

  describe "with blank title" do
    before{@report.title = " "}
    it {is_expected.not_to be_valid}
  end

  describe "with blank body_text" do
    before{@report.body_text = " "}
    it {is_expected.not_to be_valid}
  end

  pending "add some examples to (or delete) #{__FILE__}"
end
