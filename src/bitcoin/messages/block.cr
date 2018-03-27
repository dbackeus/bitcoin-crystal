module Bitcoin::Messages
  class Block < Message
    payload [
      { name: :version, type: Int32, default: Bitcoin::Protocol::BLOCK_VERSION },
      { name: :previous_block_header_hash, type: Bytes, size: 32, default: Bytes.new(32) },
      { name: :merkle_root_hash, type: Bytes, size: 32, default: Bytes.new(32) },
      { name: :time, type: UInt32, default: 0_u32 },
      { name: :bits, type: UInt32, default: 0_u32 },
      { name: :nonce, type: UInt32, default: 0_u32 },
      { name: :txns, type: Array(Messages::Tx), size: :var_int, default: Array(Messages::Tx).new }
    ]

    def id
      Protocol.sha256_twice(header_bytes).digest.reverse!.hexstring
    end

    def header_bytes
      io = IO::Memory.new

      io.write_bytes(version)
      io.write(previous_block_header_hash)
      io.write(merkle_root_hash)
      io.write_bytes(time)
      io.write_bytes(bits)
      io.write_bytes(nonce)

      io.to_slice
    end

    def inspect
      "#{self.class.name}[#{@version}]"
    end
  end
end
