# Sinatra with ActiveRecord and Faker Example

This is a simple Ruby application using Sinatra, ActiveRecord, and Faker to generate random book data and store it in a SQLite database.

## Requirements

- Ruby 2.x
- Bundler
- SQLite3 (or another database compatible with ActiveRecord)

## Installation

### Install dependencies using Bundler

```bash
bundle install
```

### Create and migrate the database (if necessary)

```bash
rake db:create db:migrate RACK_ENV=development
```

## Configuration

This project uses these gems:

- sinatra
- activerecord
- sqlite3
- faker
- sinatra-activerecord

These gems provide the functionality for the Sinatra web framework, ActiveRecord ORM, SQLite3 database, and Faker for generating fake data.

## Seeds

If you need seed with faker data run:

```bash
rake db:seed_books RACK_ENV=development
```

And access data with:

```bash
rake console
```

This task will create 10 books in the database with randomly generated titles and authors.

## Web access

Finally you can access your server with:

```bash
ruby server.rb
```

and http://localhost:4567/

And, create book with post

`http://localhost:4567/books` with args `title` and `author`

## Conclusion

This simple application demonstrates how to use Sinatra, ActiveRecord, and Faker to create a web application that manages books with random data.

You can expand this project by adding more features, such as displaying the books in a web interface or allowing users to add new books through forms.