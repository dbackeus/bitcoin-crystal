module Bitcoin::Messages
  class Inv < Message
    payload [
      {
        name: :inventory,
        type: Array(Structures::Inventory),
        size: :var_int,
        default: Array(Structures::Inventory).new
      }
    ]
  end
end
