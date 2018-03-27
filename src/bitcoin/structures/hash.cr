module Bitcoin::Structures
  class Hash < Structure
    payload [
      { name: :hash, type: Bytes, size: 32, default: Bytes.new(32) },
    ]

    def to_s
      hash.hexstring
    end
  end
end
