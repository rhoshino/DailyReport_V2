namespace :db do

  desc "Create One Sample User"
  task create_one: :environment do
    create_one
  end

  desc "Create One Admin"
  task create_admin: :environment do
    create_admin
  end

  desc "Create Develop Data"
  task create_dev_data: :environment do
    create_admin
    create_one
    p "... create dev date set"
  end

  desc "Fill database with sample data"
  task populate: :environment do
    create_admin
    create_users(10)
    create_reports
  end

  desc "Create sum reports"
  task create_reports: :environment do
    create_reports
  end

  def create_one
    name = "Sample User"
    email = "example@to.com"
    password = "12345678"

    User.create!(
          name: name,
          email: email,
          password: password,
          password_confirmation: password
      )
    p "... create sample user"
  end

  def create_users(num)
    num.times do |n|
      name = Faker::Name.name
      email = "example-#{n+1}@hoge.com"
      password = "password"
      User.create!(
        name: name,
        email: email,
        password: password,
        password_confirmation: password)
    end
    p "... create sample user#{num}"
  end

  def create_admin
    name = "Admin User"
    email = "admin@adm.com"
    password = "adminuser"
    role = "admin"
    User.create!(
          name: name,
          email: email,
          role: role,
          password: password,
          password_confirmation: password
      )
    p "... create admin user"
  end


  def create_reports
    users = User.all.limit(7)

    20.times do |n|
      title = Faker::Lorem.sentence(3)
      body_text = Faker::Lorem.sentence(10)
      reported_date = Faker::Date.backward(60)

      # faker_time = Faker::Time.between(2.days.ago, Time.now, :morning)
      work_start_time = create_hour_ust(Faker::Time.between(2.days.ago, Time.now, :morning))
      work_end_time = create_hour_ust(Faker::Time.between(2.days.ago, Time.now, :evening))

      if ((n%2).zero?)
        public_flag = true
      else
        public_flag = false
      end
      users.each do |user|
        next if user.role == 'admin'
        # binding.pry
        user.reports.create!(
          title: title,
          body_text: body_text,
          reported_date: reported_date,
          work_start_time: work_start_time,
          work_end_time: work_end_time,
          public_flag: public_flag
          )
      end
    end
    p "... create sample Reports"
  end
end

def create_hour_ust(faker_time)
  Time.new(faker_time.year.to_s,
           faker_time.mon.to_s,
           faker_time.day.to_s,
           faker_time.hour.to_s,
           faker_time.min.to_s,
           faker_time.sec.to_s,
           0)
end

# desc "print hello task"
# task "hello" do
#   p "Hello !! RAKE !!"
# end