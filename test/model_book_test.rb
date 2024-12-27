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

  def test_book_creation_invalid_without_title
    book = Book.create
    refute book.valid?
    assert_includes book.errors[:title], "can't be blank"
    assert_includes book.errors[:author], "can't be blank"
  end
end
