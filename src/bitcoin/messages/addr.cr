module Bitcoin::Messages
  class Addr < Message
    payload [
      {
        name: :addr_list,
        type: Array(Structures::NetworkAddress),
        size: :var_int,
        default: Array(Structures::NetworkAddress).new
      }
    ]

    def inspect
      "#{self.class.name}[#{addr_list.map(&.address).join(", ")}]"
    end
  end
end
