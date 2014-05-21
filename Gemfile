source 'https://rubygems.org'
ruby '2.0.0'
gem 'rails', '4.0.4'
gem 'sass-rails', '~> 4.0.1'
gem 'uglifier', '~> 2.4.0'
gem 'coffee-rails', '~> 4.0.1'
gem 'jquery-rails', '~> 3.0.4'
gem 'turbolinks', '~> 2.1.0'
gem 'jbuilder', '~> 1.5.3'
gem 'bcrypt-ruby', '~> 3.1.2'

group :doc do
  gem 'sdoc', require: false
end

# development gems
group :development, :test do
  gem 'sqlite3', '~> 1.3.8'    # dev & test database
  gem 'figaro', '~> 0.7.0'     # env variables
end

# Paging
gem 'kaminari', '~> 0.15.0'

# Slugs and friendly id's
gem 'friendly_id', '~> 5.0.2'

# font-awesome
gem 'font-awesome-sass', '~> 4.0.2'

# production gems for heroku
group :production do
  gem 'pg'
  gem 'rails_12factor'
end


# Devise
gem 'devise', '~> 3.2.2'


# Bootstrap 3
group :development, :test do
  gem 'rails_layout', '~> 0.5.11'  # Bootstrap 3 layout generator
end

gem 'bootstrap-sass', '~> 3.0.3.0'


# RSpec
group :test, :development do
  gem "rspec-rails", '~> 2.14.1'
  gem "guard-rspec"
  gem "factory_girl_rails"
  gem "spring"
  gem "guard-livereload", require: false
  gem "spring-commands-rspec"
end

# Capybara
group :test do
  gem "capybara", '~> 2.2.1'
  gem "launchy"
end

# Cucumber
group :test do
  gem "cucumber-rails", require: false
  gem "database_cleaner"
  gem "guard-cucumber"
end

# Yard
group :test, :development do
  gem 'yard', :require => false
  gem 'yard-cucumber', :require => false
  gem 'redcarpet'
  gem 'guard-yard'
  gem 'yard-rails-plugin', :git => 'https://github.com/ogeidix/yard-rails-plugin.git', :tag => 'v0.0.1'
  gem 'guard-ctags-bundler'
  gem 'pry-rails'
  gem 'pry-byebug'
end

# i18n
gem 'i18n_generators'

# Unicorn
gem 'unicorn'

# Annotation
group :development do
  gem 'annotate', '2.5.0'
end

# Codeclimate
gem "codeclimate-test-reporter", group: :test, require: nil
