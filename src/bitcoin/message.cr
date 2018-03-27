module Bitcoin
  abstract class Message < Structure
    def command
      self.class.name.split("::").last.downcase
    end

    def to_bytes : Bytes
      payload_bytes = to_payload.to_slice

      IO::Memory.new.tap do |io|
        io.write_bytes(Protocol.magic)
        io.write(Bytes.new(command.to_unsafe, 12))
        io.write_bytes(payload_bytes.size.to_u32)
        io.write(Protocol.checksum(payload_bytes))
        io.write(payload_bytes)
      end.to_slice
    end

    # overloaded by payload macro
    def to_payload : IO
      IO::Memory.new
    end
  end
end
