module Bitcoin::Messages
  class Getheaders < Message
    payload [
      { name: :version, type: UInt32, default: Bitcoin::Protocol::VERSION.to_u32 },
      { name: :block_header_hashes, type: Array(Structures::Hash), size: :varint, default: Array(Structures::Hash).new },
      { name: :stop_hash, type: Bytes, size: 32, default: Bytes.new(32) },
    ]
  end
end
