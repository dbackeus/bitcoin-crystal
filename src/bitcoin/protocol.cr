require "openssl"

module Bitcoin::Protocol
  ENVS = {
    "test" => {
      port: 18333_u16,
      magic: 0x0709110B.to_u32,
      seed: "testnet-seed.bluematt.me",
    },
    "regtest" => {
      port: 18333_u16,
      magic: 3669344250_u32,
      seed: "testnet-seed.bluematt.me",
    },
  }

  def self.config
    ENVS[ENV.fetch("BITCOIN_ENV")]?
  end

  def self.magic : UInt32
    config ? config.not_nil![:magic] : 0xD9B4BEF9.to_u32
  end

  def self.port : UInt16
    config ? config.not_nil![:port] : 8333_u16
  end

  def self.dns_seed_address : String
    config ? config.not_nil![:seed] : "seed.bitcoin.sipa.be"
  end

  VERSION = 70015_i32
  BLOCK_VERSION = 4_u32
  SERVICES = 0_u64
  USER_AGENT = "/Bitcoin-Crystal:0.0.1/"
  NONCE = rand 0xffffffffffffffff # aka node id

  def self.checksum(payload_bytes)
    sha256_twice(payload_bytes).hexdigest[0..7].hexbytes
  end

  def self.sha256_twice(bytes) : OpenSSL::Digest
    hash1 = OpenSSL::Digest.new("SHA256").update(bytes)
    hash2 = OpenSSL::Digest.new("SHA256").update(hash1.digest)
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

  def self.write_var_int(io, size)
    if size < 0xFD
      io.write_byte(size.to_u8)
    elsif size <= 0xFFFF
      io.write_byte(0xFD.to_u8)
      io.write_bytes(size.to_u16)
    elsif size <= 0xFFFFFF
      io.write_byte(0xFE.to_u8)
      io.write_bytes(size.to_u32)
    elsif size <= 0xFFFFFFFF
      io.write_byte(0xFF.to_u8)
      io.write_bytes(size.to_u64)
    else
      raise "Invalid size: #{size}"
    end
  end
end
