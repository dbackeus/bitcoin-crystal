module Bitcoin::Messages
  class Pong
    def self.from_payload(io : IO)
      new(nonce: io.read_bytes(UInt64))
    end

    getter :nonce

    def initialize(@nonce : UInt64)
    end

    def to_payload : IO
      IO::Memory.new.tap do |io|
        io.write_bytes(@nonce)
      end
    end
  end
end
