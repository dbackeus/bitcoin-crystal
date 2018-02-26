module Bitcoin::Messages
  class Ping < Message
    payload [
      { name: :nonce, type: UInt64, default: rand(0xFFFFFFFFFFFFFFFF) }
    ]
  end
end
