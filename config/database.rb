require "sinatra/activerecord"

env = ENV['RACK_ENV'] || 'development'

db_config = {
  development: {
    adapter: 'sqlite3',
    database: 'db/development.sqlite3'
  },
  test: {
    adapter: 'sqlite3',
    database: 'db/test.sqlite3'
  }
}


ActiveRecord::Base.establish_connection(db_config[env.to_sym])
