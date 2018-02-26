require "openssl"

module Bitcoin::Protocol
  MAINNET_MAGIC = 0xD9B4BEF9.to_u32
  VERSION = 70015_i32
  SERVICES = 0_u64
  USER_AGENT = "/Bitcoin-Crystal:0.0.1/"
  NONCE = rand 0xffffffffffffffff # aka node id

  def self.message(command : String, payload : IO) : Bytes
    message = IO::Memory.new

    message.write_bytes(MAINNET_MAGIC)

    command_bytes = Bytes.new(12) { |i| command[i]?.try &.ord.to_u8 || 0_u8 }
    message.write(command_bytes)

    message.write_bytes(payload.size.to_u32)

    payload_bytes = Bytes.new(payload.size)
    payload.rewind
    payload.read(payload_bytes)

    message.write(checksum(payload_bytes))

    message.write(payload_bytes)

    message_bytes = Bytes.new(message.size)
    message.rewind
    message.read(message_bytes)

    message_bytes
  end

  def self.version_message(to_ip, to_port, last_block)
    payload = IO::Memory.new

    payload.write_bytes(VERSION)
    payload.write_bytes(SERVICES)
    payload.write_bytes(Time.now.epoch.to_i64)

    write_network_address(payload, "127.0.0.1", 8333)
    write_network_address(payload, to_ip, to_port)

    payload.write_bytes(NONCE)
    payload.write_byte(USER_AGENT.size.to_u8)
    payload.write(USER_AGENT.to_slice)
    payload.write_bytes(last_block.to_i32) # block height

    message("version", payload)
  end

  def self.write_network_address(io, ip : String, port)
    io.write_bytes(SERVICES)
    10.times { io.write_byte(0_u8) }
    2.times { io.write_byte(255_u8) }
    ip.split(".").map(&.to_u8).each { |octet| io.write_byte(octet) }
    io.write_bytes(port.to_u16)
  end

  def self.checksum(payload_bytes)
    hash = OpenSSL::Digest.new("SHA256")
    hash.update(payload_bytes)

    hash2 = OpenSSL::Digest.new("SHA256")
    hash2.update(hash.digest)

    hash2.hexdigest[0..7].hexbytes
  end

  def self.read_var_int(io)
    first = io.read_byte.not_nil!
    if first < 0xFD
      first
    elsif first == 0xFD
      io.read_bytes(UInt16, IO::ByteFormat::LittleEndian)
    elsif first == 0xFE
      io.read_bytes(UInt32, IO::ByteFormat::LittleEndian)
    elsif first == 0xFF
      io.read_bytes(UInt64, IO::ByteFormat::LittleEndian)
    else
      raise "Invalid var int"
    end.to_u64
  end

  def write_var_int(io, size)
    if size < 0xFD
      io.write_byte(size.to_u8)
    elsif size <= 0xFFFF
      io.write_byte(0xFD)
      io.write_bytes(size.to_u16)
    elsif size <= 0xFFFFFF
      io.write_byte(0xFE)
      io.write_bytes(size.to_u32)
    elsif size <= 0xFFFFFFFF
      io.write_byte(0xFF)
      io.write_bytes(size.to_u64)
    else
      raise "Invalid size: #{size}"
    end
  end
end
