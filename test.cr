require "socket"
require "./src/bitcoin"

initial_ips = `nslookup seed.bitcoin.sipa.be`.scan(/Address\: (.+)/).map(&.[1])
initial_ip = initial_ips.sample

puts "attempting connection to #{initial_ip}"
socket = TCPSocket.new initial_ip, 8333

puts "connected, sending version message"

version_message = Bitcoin::Protocol.version_message(initial_ip, 8333, 0)
socket.send version_message

puts "reading message..."
puts read_message(socket)

def read_message(socket)
  magic = socket.read_bytes(UInt32)
  command = socket.read_string(12)
  size = socket.read_bytes(UInt32)
  checksum = Bytes.new(4)
  socket.read(checksum)

  payload = Bytes.new(size)
  socket.read(payload)

  calculated_checksum = Bitcoin::Protocol.checksum(payload)

  if calculated_checksum == checksum
    puts "Successfully received '#{command}' message"
  else
    puts "WARNING: Checksum mismatch, skipping message"
  end
end
