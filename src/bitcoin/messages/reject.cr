require "colorize"

module Bitcoin::Messages
  class Reject < Message
    CCODES = {
      0x01 => "REJECT_MALFORMED",
      0x10 => "REJECT_INVALID",
      0x11 => "REJECT_OBSOLETE",
      0x12 => "REJECT_DUPLICATE",
      0x40 => "REJECT_NONSTANDARD",
      0x41 => "REJECT_DUST",
      0x42 => "REJECT_INSUFFICIENTFEE",
      0x43 => "REJECT_CHECKPOINT",
    }

    payload [
      { name: :message, type: String, size: :var_int, default: "" },
      { name: :ccode, type: UInt8, size: :varint, default: 0x01 },
      { name: :reason, type: String, size: :var_int, default: "" },
      #{ name: :data, type: Bytes, size: 32, default: Bytes.new(32) },
    ]

    def inspect
      "#{self.class.name}[#{message}, #{ccode_readable}, #{reason}]".colorize(:light_red)
    end

    def ccode_readable
      CCODES[ccode]? || "UNKNOWN"
    end
  end
end
