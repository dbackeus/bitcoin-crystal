# https://bitcoin.org/en/developer-reference#txout

module Bitcoin::Structures
  class TxOut < Structure
    payload [
      { name: :value, type: Int64, default: 0_i64 },
      { name: :pk_script, type: Bytes, size: :var_int, default: Bytes.new(0) },
    ]
  end
end
