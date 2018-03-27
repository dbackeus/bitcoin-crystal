# https://bitcoin.org/en/developer-reference#raw-transaction-format

module Bitcoin::Messages
  class Tx < Message
    payload [
      { name: :version, type: Int32, default: 1_i32 },
      { name: :tx_in, type: Array(Structures::TxIn), size: :var_int, default: Array(Structures::TxIn).new },
      { name: :tx_out, type: Array(Structures::TxOut), size: :var_int, default: Array(Structures::TxOut).new },
      { name: :lock_time, type: UInt32, default: 0_u32 },
    ]

    def id
      Protocol.sha256_twice(to_payload.to_slice).digest.reverse!.hexstring
    end

    def inspect
      "#{self.class.name}[#{@version}]"
    end
  end
end
