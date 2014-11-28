namespace :db do

  desc "Create One Sample User"
  task create_one: :environment do
    create_one
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
  end


end



# desc "print hello task"
# task "hello" do
#   p "Hello !! RAKE !!"
# end