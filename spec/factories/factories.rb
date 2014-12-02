FactoryGirl.define do
  factory :user do

    sequence(:name){|n| "Person #{n}"}
    sequence(:email){|n| "person_#{n}@example.com"}

    password "password"

  end


  factory :report do
    title "Example Report"
    body_text "Lolem ipsum"
    reported_time
    user

  end

end