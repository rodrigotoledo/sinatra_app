require 'sinatra'
require "sinatra/reloader"
require 'json'
require 'faye/websocket'
require 'eventmachine'
require './config/database'
require './lib/book'
require 'rack/cors'
class MyApp < Sinatra::Base
  use Rack::Cors do
    allow do
      origins 'http://localhost:3000'
      resource '*',
        headers: :any,
        methods: [:get, :post, :options, :put, :delete]
    end
  end
  class WebSocketManager
    @clients = []

    class << self
      attr_accessor :clients

      def add_client(ws)
        @clients << ws
      end

      def remove_client(ws)
        @clients.delete(ws)
      end

      def broadcast_books
        @clients.each do |client|
          response = { action: "update_books", books: Book.order(id: :desc) }
          client.send(response.to_json)
        end
      end
    end
  end

  def fetch_books
    @books = Book.order(id: :desc)
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
    @books.to_json
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
          response = { status: "create_book", book: book.attributes }
          ws.send(response.to_json)
          WebSocketManager.broadcast_books
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
MyApp.run!
