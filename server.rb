require 'sinatra'
require "sinatra/reloader"
require 'json'
require 'faye/websocket'
require 'eventmachine'
require './lib/book'
require './lib/web_socket_manager'
require 'rack/cors'
class Server < Sinatra::Base
  use Rack::Cors do
    allow do
      origins 'http://localhost:3000'
      resource '*',
        headers: :any,
        methods: [:get, :post, :options, :put, :delete]
    end
  end

  def fetch_books
    @books = Book.order(Sequel.desc(:id)).all
  end

  post '/books' do
    book_params = JSON.parse(request.body.read)
    book = Book.new(title: book_params['title'], author: book_params['author'])

    if book.valid? && book.save
      status 201
      book.to_hash.to_json
    else
      status 422
      { error: book.errors.full_messages }.to_json
    end
  end

  get '/books' do
    fetch_books
    @books.map(&:to_hash).to_json
  end

  get '/' do
    fetch_books
    erb :index
  end

  get '/ws' do
    if Faye::WebSocket.websocket?(env)
      ws = Faye::WebSocket.new(env)

      WebSocketManager.add_client(ws)

      ws.on :message do |event|
        message = JSON.parse(event.data)

        if message["action"] == "create_book"
          book = Book.create(title: message["title"], author: message["author"])
          response = { status: "create_book", book: book.to_hash }
          ws.send(response.to_json)
        end
      end

      ws.on :close do |event|
        WebSocketManager.remove_client(ws)
      end

      ws.rack_response
    else
      fetch_books
      erb :index
    end
  end
end
