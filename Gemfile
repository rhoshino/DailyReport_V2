source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.7'
# Use postgresql as the database for Active Record
# gem 'pg'
gem 'pg', '~> 0.18.0.pre20141117110243'

#use authlization
gem 'devise'
# gem 'cancan'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

#Use bootstrap
gem 'bootstrap-sass','2.3.2.0'
gem 'sprockets', '2.11.3'

#Use data
gem 'faker'

group :development , :test do
  #use Rspec
  gem 'rspec-rails'

  #use pry
  gem 'pry', '< 0.10.0'
  gem 'pry-rails'
  gem 'hirb'
  gem 'hirb-unicode'
  gem 'binding_of_caller'
  gem 'pry-byebug'
end

group :test do
  #use Capybara
  gem 'selenium-webdriver'
  gem 'capybara'
  gem 'launchy'
  #use Factoly girl
  gem 'factory_girl_rails','4.2.1'
  gem 'database_cleaner',"~> 1.0.1"
  #gem 'capybara-screenshot'
end

group :production do
  gem 'rails_12factor'# use to heroku
end

# Use debugger
# gem 'debugger', group: [:development, :test]

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw]
