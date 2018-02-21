require "openssl"

SERVICES = 1_u64
USER_AGENT = "/Satoshi:0.7.2/"

message = IO::Memory.new

# magic main net
message.write_bytes(0xD9B4BEF9.to_u32, IO::ByteFormat::LittleEndian)

# version command
command = "version"
command_bytes = Bytes.new(12)
command.each_char_with_index {|c, i| command_bytes[i] = c.ord.to_u8}
message.write(command_bytes)

# payload
payload = IO::Memory.new

payload.write_bytes(60002_i32) # version
payload.write_bytes(SERVICES) # services
payload.write_bytes(1355854353_i64) # timestamp

write_network_address(payload, SERVICES, "0.0.0.0", 0)
write_network_address(payload, SERVICES, "0.0.0.0", 0)

payload.write_bytes(7284544412836900411_u64) # random nonce / node id
payload.write_byte(USER_AGENT.size.to_u8)
payload.write(USER_AGENT.to_slice)
payload.write_bytes(212672_i32) # block height

# payload size
message.write_bytes(payload.size.to_u32, IO::ByteFormat::LittleEndian)

# checksum
payload.rewind
payload_slice = Bytes.new(payload.size)
payload.read_fully(payload_slice)

checksum = payload_checksum(payload_slice)
message.write(checksum)

# payload
message.write(payload_slice)

message.rewind
message_slice = Bytes.new(message.size)
message.read_fully(message_slice)

puts "message:"
puts message_slice.hexdump

def payload_checksum(payload_slice)
  hash = OpenSSL::Digest.new("SHA256")
  hash.update(payload_slice)

  hash2 = OpenSSL::Digest.new("SHA256")
  hash2.update(hash.digest)
  hash2.hexdigest[0..7].hexbytes
end

def write_network_address(io, services : UInt64, ip : String, port)
  io.write_bytes(services)
  10.times { io.write_byte(0_u8) }
  2.times { io.write_byte(255_u8) }
  ip.split(".").map(&.to_u8).each { |octet| io.write_byte(octet) }
  io.write_bytes(port.to_i16)
end
