module Bitcoin::Structures
  class BlockHeader < Structure
    payload [
      { name: :version, type: Int32, default: Bitcoin::Protocol::BLOCK_VERSION },
      { name: :previous_block_header_hash, type: Bytes, size: 32, default: Bytes.new(32) },
      { name: :merkle_root_hash, type: Bytes, size: 32, default: Bytes.new(32) },
      { name: :time, type: UInt32, default: 0_u32 },
      { name: :bits, type: UInt32, default: 0_u32 },
      { name: :nonce, type: UInt32, default: 0_u32 },
    ]
  end
end
