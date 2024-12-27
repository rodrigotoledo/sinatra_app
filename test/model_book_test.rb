require 'minitest/autorun'
require 'active_record'
require_relative '../config/database'
require_relative '../lib/book'
class BookTest < Minitest::Test

  def test_book_creation
    book = Book.create(title: 'The Great Gatsby', author: 'F. Scott Fitzgerald')
    assert_equal 'The Great Gatsby', book.title
    assert_equal 'F. Scott Fitzgerald', book.author
  end
end
