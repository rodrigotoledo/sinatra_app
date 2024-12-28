# Sinatra with Sequel, WS and Faker Example

This is a simple Ruby application using Sinatra, Sequel, and Faker to generate random book data and store it in a SQLite database.

## Requirements

- Ruby 2.x
- Bundler
- SQLite3 (or another database compatible with Sequel)

## Installation

### Install dependencies using Bundler

```bash
bundle install
```

## Configuration

This project uses these gems:

- sinatra
- sequel
- sqlite3
- faker

These gems provide the functionality for the Sinatra web framework, Sequel ORM, SQLite3 database, and Faker for generating fake data.

## Seeds

If you need seed with faker data run:

```bash
rake db:seed_books RACK_ENV=development
```

This task will create 10 books in the database with randomly generated titles and authors.

## Web access, with database

Finally you can access your server with:

```bash
rackup
```

and http://localhost:9292/

And, create book with post

`http://localhost:9292/books` with args `title` and `author`

## WS actions

Using websocket its possible to create books in real time, first install a tool to run WS client with:

```bash
npm install -g wscat
```

And start the client with:

```bash
wscat -c ws://localhost:9292/ws
```

Inside the client you can create registers with:

`{"action": "create_book", "title": "1984", "author": "George Orwell"}`

## Testing

This application use minitest with unit and controller coverage, run:

```bash
rake test
```

## Conclusion

This simple application demonstrates how to use Sinatra, Sequel, and Faker to create a web application that manages books with random data.

You can expand this project by adding more features, such as displaying the books in a web interface or allowing users to add new books through forms.
