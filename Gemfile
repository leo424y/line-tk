source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby "3.0.1"


gem "autoprefixer-rails"

gem "bootsnap", require: false
# gem "honeybadger"
gem "pg"
gem "puma"
gem "rack-canonical-host"
gem "rails", "~> 6.0.0"
gem "recipient_interceptor"
gem "sassc-rails"
gem "skylight"
gem "sprockets", "< 4"
gem "title"
gem "tzinfo-data", platforms: [:mingw, :x64_mingw, :mswin, :jruby]
gem "webpacker"
gem 'ransack'
gem 'stimulus-rails'
gem 'ruby-limiter'
gem 'line-bot-api'

group :development do
  gem "listen"
  gem "web-console"
end

group :development, :test do
  gem "awesome_print"
  gem "pry-byebug"
  gem "pry-rails"
end

group :test do
  gem "formulaic"
  gem "launchy"
  gem "timecop"
  gem "webmock"
end

gem "suspenders", group: [:development, :test]

gem 'rack-mini-profiler', require: false

gem "tailwindcss-rails", github: "dorianmariefr/tailwindcss-rails", branch: "minimal"
