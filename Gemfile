source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

gem 'rails', '5.2.0'

gem 'sqlite3', '1.3.13'

gem 'puma', '3.11.4'
gem 'rack-cors', '1.0.2'

gem 'bootsnap', require: false

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'listen', '3.1.5'
end

group :test do
  gem 'rspec-rails', '3.7.2'
end
