require 'google-search'
require 'hipchat'
require 'socket'
require 'json'

tokens =  {
  'room name' => 'PLACE INTEGRATION API KEY HERE',
  'other room' => 'PLACE INTEGRATION API KEY HERE'
}
# Set the listen port here. Ports over 1024 are recommended so non-root user can bind.
server = TCPServer.new('0.0.0.0', 8080)
# Set the command configured in integration screen in Hipchat Admin
command = '/i'
# What color to use when posting results to room
color = 'green'

loop do
  begin
    socket = server.accept
    method, path = socket.gets.split
    headers = {}
    while line = socket.gets.split(' ', 2)              # Collect HTTP headers
      break if line[0] == ""                            # Blank line means no more headers
      headers[line[0].chop] = line[1].strip
    end
    data = socket.read(headers["Content-Length"].to_i)
    if method == 'POST'
      json = JSON.parse data
      if json['event'] == 'room_message'
        m = json['item']['message']['message']
        r = json['item']['room']['name']
        if m.start_with? command
          query = m.split(' ')[1..-1]
          animated = query.include? "ani"
          query = query.select{|x| "ani" != x}.join(' ')
          print "googling #{animated ? '(animated) ' : ''}#{query}: "
          img = Google::Search::Image.new(:query => query, :safe => :active, :imgtype => animated ? "animated" : "any").first
          puts "#{img.uri}"
          hc = HipChat::Client.new(tokens[r], :api_version => 'v2')
          hc[r].send('Google', img.uri, :color => color,  :message_format => 'text')
        end
      end
    end
  rescue Exception => e
    puts e
  end

  socket.print "HTTP/1.1 204 No Content\r\n" +
               "Content-Type: text/plain\r\n" +
               "Content-Length: 0\r\n" +
               "Connection: close\r\n"
  socket.print "\r\n"
  socket.close
end
