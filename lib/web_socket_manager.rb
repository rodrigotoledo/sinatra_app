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
        response = { action: "update_books", books: Book.order(Sequel.desc(:id)).all.map{|t| t.to_hash} }
        client.send(response.to_json)
      end
    end
  end
end
