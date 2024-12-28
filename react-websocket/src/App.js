import React, { useState, useEffect } from 'react';

function App() {
  const [title, setTitle] = useState('');
  const [author, setAuthor] = useState('');
  const [messages, setMessages] = useState([]);
  const [ws, setWs] = useState(null);

  useEffect(() => {
    fetch('http://localhost:4567/books')
      .then((response) => response.json())
      .then((data) => {
        setMessages(data);
      })
      .catch((error) => {
        console.error('Error fetching books:', error);
      });

    const socket = new WebSocket('ws://localhost:4567/ws');

    socket.onopen = (event) => {
      console.log('Connected to WebSocket');
    };

    socket.onmessage = (event) => {
      const response = JSON.parse(event.data);

      if (response.status === "create_book") {
        const newBook = response.book;
        setMessages((prevMessages) => [...prevMessages, newBook]);
      }

      if (response.action === "update_books") {
        setMessages(response.books);
      }
    };

    socket.onclose = () => {
      console.log('Disconnected from WebSocket');
    };

    setWs(socket);

    return () => {
      socket.close();
    };
  }, []);

  const handleSubmit = (e) => {
    e.preventDefault();

    if (ws && title && author) {
      const message = JSON.stringify({
        action: "create_book",
        title: title,
        author: author
      });

      ws.send(message);
      setTitle('');
      setAuthor('');
    }
  };

  return (
    <div className="App">
      <link rel="stylesheet" href="https://cdn.simplecss.org/simple.min.css" />
      <h1>WebSocket tests with Sinatra and JSON</h1>
      <main>
        <h2>Fill with book info</h2>
        <form onSubmit={handleSubmit}>
          <input
            type="text"
            value={title}
            onChange={(e) => setTitle(e.target.value)}
            placeholder="Title of the book"
            required
          />
          <input
            type="text"
            value={author}
            onChange={(e) => setAuthor(e.target.value)}
            placeholder="Author of the book"
            required
          />
          <button type="submit">Create Book</button>
        </form>
        <hr />
        <h3>Books</h3>
        <div>
          {messages.length === 0 ? (
            <p>No books yet.</p>
          ) : (
            <>
              {messages.map((book, index) => (
                <pre key={index}>
                  {JSON.stringify(book)}
                </pre>
              ))}
            </>
          )}
        </div>
      </main>
    </div>
  );
}

export default App;
