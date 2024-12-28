require 'minitest/autorun'
require 'rack/test'
require_relative '../server'

class BooksControllerTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Server.new
  end

  def test_get_books
    Book.create(title: 'The Great Gatsby', author: 'F. Scott Fitzgerald')

    get '/books'
    assert_equal 200, last_response.status
    assert_includes last_response.body, 'The Great Gatsby'
  end

  def test_get_root
    Book.create(title: 'The Great Gatsby', author: 'F. Scott Fitzgerald')

    get '/'
    assert_equal 200, last_response.status
    assert_includes last_response.body, 'The Great Gatsby'
  end

  def test_post_books
    post '/books', { title: '1984', author: 'George Orwell' }.to_json, { 'CONTENT_TYPE' => 'application/json' }
    assert_equal 201, last_response.status
    response = last_response.body
    assert_includes response, '1984'
  end

  def test_post_books_invalid_without_title
    post '/books', { author: 'George Orwell' }.to_json, { 'CONTENT_TYPE' => 'application/json' }

    assert_equal 422, last_response.status
    assert_includes last_response.body, 'title'
  end

  def test_post_books_invalid_without_author
    post '/books', { title: '1984' }.to_json, { 'CONTENT_TYPE' => 'application/json' }

    assert_equal 422, last_response.status
    assert_includes last_response.body, 'author'
  end
end
