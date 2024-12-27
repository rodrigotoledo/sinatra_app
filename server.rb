require 'sinatra'
require "sinatra/reloader"
require 'json'
require './config/database'
require './lib/book'

def fetch_books
  books = Book.all
  books.to_json
end

post '/books' do
  book_params = JSON.parse(request.body.read)
  book = Book.create(title: book_params['title'], author: book_params['author'])

  status 201
  book.to_json
end

get '/books' do
  fetch_books
end

get '/' do
  fetch_books
end
