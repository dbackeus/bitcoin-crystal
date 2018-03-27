module Bitcoin::Messages
  class Headers < Message
    payload [
      {
        name: :headers,
        type: Array(Structures::BlockHeader),
        size: :var_int,
        default: Array(Structures::BlockHeader).new
      }
    ]
  end
end
