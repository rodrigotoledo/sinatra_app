require 'faker'
require_relative 'lib/book'

namespace :db do
  desc "Creates 10 books with FAKER"
  task :seed_books do
    10.times do
      Book.create(
        title: Faker::Book.title,
        author: Faker::Book.author
      )
    end
  end
end

task :test do
  Dir.glob('test/**/*_test.rb').each do |test_file|
    system("RACK_ENV=test bundle exec ruby #{test_file}")
  end
end
