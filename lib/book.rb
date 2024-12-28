require 'sequel'
require_relative 'web_socket_manager'
env = ENV['RACK_ENV'] || 'developmnet'
DB = Sequel.connect("sqlite://db/#{env}.sqlite3")

unless DB.table_exists?(:books)
  DB.create_table :books do
    primary_key :id
    String :title
    String :author
  end
end
class Book < Sequel::Model
  def validate
    super
    errors.add(:title, 'cannot be empty') if title.nil? || title.strip.empty?
    errors.add(:author, 'cannot be empty') if author.nil? || author.strip.empty?
  end

  def after_create
    WebSocketManager.broadcast_books
  end
end
