require 'rails_helper'

RSpec.describe User, :type => :model do

  before do
    @user = User.new(name: "Example",
                     email: "user@example.com",
                     password: "12345678",
                     sendto_address: "send@to.com"
                     )
  end

  subject{@user}

  #Check User's Proparty
  it {is_expected.to respond_to(:email)}
  it {is_expected.to respond_to(:name)}
  it {is_expected.to respond_to(:encrypted_password)}
  it {is_expected.to respond_to(:sendto_address)}

  #Validatable?
  it {is_expected.to be_valid}

  describe "Validatable Check" do
    describe "name is not found" do
      before{@user.name = " "}
      it{is_expected.not_to be_valid}
    end

    describe "email is not found" do
      before{@user.email = " "}
      it{is_expected.not_to be_valid}
    end

    describe "password is not found" do
       before{@user.password = " "}
      it{is_expected.not_to be_valid}
    end

    describe "password is too short" do
       before{@user.password = "1234"}
      it{is_expected.not_to be_valid}
    end

  end# Validatable check

  pending "add some examples to (or delete) #{__FILE__}"
end
