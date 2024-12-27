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

  if book.save
    status 201
    book.to_json
  else
    status 422
    { error: book.errors.full_messages.join(', ') }.to_json
  end
end

get '/books' do
  fetch_books
end

get '/' do
  fetch_books
end
