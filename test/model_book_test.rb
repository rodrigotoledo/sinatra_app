require 'minitest/autorun'
require_relative '../lib/book'
class BookTest < Minitest::Test

  def test_book_creation
    book = Book.create(title: 'The Great Gatsby', author: 'F. Scott Fitzgerald')
    assert_equal 'The Great Gatsby', book.title
    assert_equal 'F. Scott Fitzgerald', book.author
  end

  def test_book_creation_invalid_without_title
    book = Book.new
    book.valid?
    assert book.errors.has_key?(:author)
    assert book.errors.has_key?(:title)
  end
end
