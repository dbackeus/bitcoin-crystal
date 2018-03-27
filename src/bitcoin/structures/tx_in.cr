# https://bitcoin.org/en/developer-reference#txout

module Bitcoin::Structures
  class TxIn < Structure
    payload [
      { name: :outpoint_hash, type: Bytes, size: 32, default: Bytes.new(32) },
      { name: :outpoint_index, type: UInt32, default: 0_u32 },
      { name: :signature_script, type: Bytes, size: :var_int, default: Bytes.new(0) },
      { name: :sequence, type: UInt32, default: 0xFFFFFFFF.to_u32 },
    ]

    def readable_outpoint_hash
      outpoint_hash.clone.reverse!.hexstring
    end
  end
end
