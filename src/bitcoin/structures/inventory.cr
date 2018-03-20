module Bitcoin::Structures
  class Inventory < Structure
    # TODO: How to handle type as an enum?

    payload [
      { name: :type, type: UInt32 },
      { name: :hash, type: Bytes, size: 32 },
    ]

    TYPES = {
      0 => "ERROR",
      1 => "MSG_TX",
      2 => "MSG_BLOCK",
      3 => "MSG_FILTERED_BLOCK",
      4 => "MSG_CMPCT_BLOCK",
    }

    def inspect
      "#{self.class.name}[#{TYPES[type]}]"
    end
  end
end
