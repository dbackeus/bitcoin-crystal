module Bitcoin::Messages
  class Getdata < Message
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
