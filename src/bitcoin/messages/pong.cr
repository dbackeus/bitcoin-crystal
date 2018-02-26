module Bitcoin::Messages
  class Pong < Message
    payload [
      { name: :nonce, type: UInt64 }
    ]
  end
end
