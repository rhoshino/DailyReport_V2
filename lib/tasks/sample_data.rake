namespace :db do

  desc "Create One Sample User"
  task create_one: :environment do
    create_one
  end

  desc "Create One Admin"
  task create_admin: :environment do
    create_admin
  end

  desc "Create Develop Date"
  task create_dev_date: :environment do
    create_admin
    create_one
    p "... create dev date set"
  end

  desc "Fill database with sample data"
  task populate: :environment do
    create_users(10)
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
    users = User.all.limit(6)

    10.times do |n|
      title = Faker::Lorem.sentence(3)
      body_text = Faker::Lorem.sentence(10)
      reported_date = Faker::Date.backward(60)

      if ((n%2).zero?)
        public_flag = true
      else
        public_flag = false
      end
      users.each do |user|
        user.reports.create!(
          title: title,
          body_text: body_text,
          reported_date: reported_date,
          public_flag: public_flag
          )
      end
    end
    p "... create sample Reports"
  end
end



# desc "print hello task"
# task "hello" do
#   p "Hello !! RAKE !!"
# end