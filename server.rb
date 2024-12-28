require 'sinatra'
require "sinatra/reloader"
require 'json'
require 'faye/websocket'
require 'eventmachine'
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
  @books = Book.all
  erb :index
end

get '/ws' do

  if Faye::WebSocket.websocket?(env)
    ws = Faye::WebSocket.new(env)

    ws.on :message do |event|
      message = JSON.parse(event.data)
      book = Book.create(title: message["title"], author: message["author"])
      response = { status: "success", book: book.attributes }
      ws.send(response.to_json)
    end

    ws.rack_response
  else
    @books = Book.all
    erb :index
  end
end
