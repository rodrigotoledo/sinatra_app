require 'sinatra/activerecord/rake'
require 'faker'
require_relative 'config/database'
require_relative 'lib/book'

namespace :db do
  desc "Creates 10 books with FAKER"
  task :seed_books => :environment do
    10.times do
      Book.create(
        title: Faker::Book.title,
        author: Faker::Book.author
      )
    end
  end
end
