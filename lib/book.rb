require 'active_record'

class Book < ActiveRecord::Base
  validates :author, :title, presence: true
end
