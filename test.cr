require "socket"
require "./src/bitcoin"

module Bitcoin
  def self.random_seed
    puts "Looking up DNS seeds"
    ips = `nslookup seed.bitcoin.sipa.be`.scan(/Address\: (.+)/).map(&.[1])
    ips.sample
  end

  def self.connection
    @@connection ||= TCPSocket.new(random_seed, 8333)
  end
end

puts "connected, sending version message"

ip_address = Bitcoin.connection.remote_address

send Bitcoin::Messages::Version.new

read # version
read # verack

# send Bitcoin::Protocol.message("getaddr", IO::Memory.new)

loop do
  read

  sleep 1
end

def send(message : Bitcoin::Message)
  bytes = message.to_bytes

  puts "Sending:"
  puts bytes.hexdump

  Bitcoin.connection.send(bytes)
end

def read
  puts "reading..."

  socket = Bitcoin.connection

  while socket.peek.size < 24
    sleep 0.1
  end

  magic = socket.read_bytes(UInt32)
  command = socket.read_string(12).strip("\u{0}")
  size = socket.read_bytes(UInt32)
  checksum = Bytes.new(4)
  socket.read(checksum)

  while socket.peek.size < size
    sleep 0.1
  end

  payload = Bytes.new(size)
  socket.read(payload)

  calculated_checksum = Bitcoin::Protocol.checksum(payload)

  if calculated_checksum == checksum
    puts "Successfully received '#{command}' message:"
    # puts payload.hexdump

    payload_io = IO::Memory.new(payload, false)

    if command == "version"
      version_message = Bitcoin::Messages::Version.from_payload payload_io
      puts version_message.inspect

      send Bitcoin::Messages::Verack.new
    elsif command == "ping"
      ping = Bitcoin::Messages::Ping.from_payload payload_io
      send Bitcoin::Messages::Pong.new(nonce: ping.nonce)
    elsif command == "addr"
      addr = Bitcoin::Messages::Addr.from_payload payload_io
      puts addr.inspect
    elsif command == "inv"
      inv = Bitcoin::Messages::Inv.from_payload payload_io
      inv.inventory.each do |inventory|
        puts inventory.inspect
      end
    end
  else
    puts "WARNING: Checksum mismatch, skipping message"
  end
end
