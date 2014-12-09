
FactoryGirl.define do
  factory :user do

    sequence(:name){|n| "Person #{n}"}
    sequence(:email){|n| "person_#{n}@example.com"}

    password "password"

    role nil

  end


  factory :report do
    title "Example Report"
    body_text "Lolem ipsum"
    reported_date "2014-12-25"
    user
    public_flag nil

  end

end