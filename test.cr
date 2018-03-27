require "dotenv"
Dotenv.load

require "socket"
require "./src/bitcoin"

module Bitcoin
  def self.random_seed
    puts "Looking up DNS seeds"
    ips = `nslookup #{Bitcoin::Protocol.dns_seed_address}`.scan(/Address\: (.+)/).map(&.[1])
    ips.sample
  end

  def self.connection
    @@connection ||= TCPSocket.new(random_seed, Bitcoin::Protocol.port)
  end
end

ip_address = Bitcoin.connection.remote_address
puts "connected to #{ip_address}"

send Bitcoin::Messages::Version.new(start_height: 1289220)
read # version
send Bitcoin::Messages::Verack.new
read # verack

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
  puts "#read"

  socket = Bitcoin.connection

  until socket.peek.size >= 24
    sleep 0.1
  end

  magic = socket.read_bytes(UInt32)
  command = socket.read_string(12).strip("\u{0}")
  size = socket.read_bytes(UInt32)
  checksum = Bytes.new(4) { socket.read_byte.not_nil! }

  payload = Bytes.new(size.to_i32) {
    until socket.peek.size > 0
      sleep 0.01
    end
    socket.read_byte.not_nil!
  }

  # puts payload.hexdump.colorize(:dark_gray)

  calculated_checksum = Bitcoin::Protocol.checksum(payload)

  if calculated_checksum == checksum
    puts "Received '#{command}' message"

    payload_io = IO::Memory.new(payload, false)

    if command == "version"
      version_message = Bitcoin::Messages::Version.from_payload payload_io
      puts version_message.inspect
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

        if inventory.type == 1
          # transaction
          send Bitcoin::Messages::Getdata.new(inventory: [inventory])
        elsif inventory.type == 2
          # block
          send Bitcoin::Messages::Getdata.new(inventory: [inventory])
        end
      end
    elsif command == "block"
      message = Bitcoin::Messages::Block.from_payload payload_io
      puts message.inspect
    elsif command == "tx"
      tx = Bitcoin::Messages::Tx.from_payload payload_io
      puts tx.inspect
    elsif command == "getheaders"
      send Bitcoin::Messages::Headers.new
    elsif command == "reject"
      message = Bitcoin::Messages::Reject.from_payload payload_io
      puts message.inspect
    end
  else
    puts "WARNING: Checksum mismatch, skipping message"
  end
end
