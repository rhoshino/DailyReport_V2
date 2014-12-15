
FactoryGirl.define do
  factory :user do

    sequence(:name){|n| "Person #{n}"}
    sequence(:email){|n| "person_#{n}@example.com"}

    password "password"

    role nil

  end#user


  factory :report do
    title "Example Report"
    body_text "Lolem ipsum"
    reported_date "2014-12-25"
    work_start_time Faker::Time.between(2.days.ago, Time.now, :morning)
    # work_start_time
    work_end_time Faker::Time.between(2.days.ago, Time.now, :evening)
    # work_end_time
    user
    public_flag true


    # after_build do |obj|
    #   obj.work_start_time = create_hour_ust( Faker::Time.between(2.days.ago, Time.now, :morning) )
    #   obj.work_end_time = create_hour_ust( Faker::Time.between(2.days.ago, Time.now, :evening) )
    # end

    # def create_hour_ust(faker_time)
    #   Time.new(faker_time.year.to_s,
    #            faker_time.mon.to_s,
    #            faker_time.day.to_s,
    #            faker_time.hour.to_s,
    #            faker_time.min.to_s,
    #            faker_time.sec.to_s,
    #            0)
    # end

  end#report




end

