module Bitcoin::Structures
  class NetworkAddress < Structure
    payload [
      { name: :time, type: UInt32, default: Time.now.epoch.to_u32 },
      { name: :services, type: UInt64, default: Bitcoin::Protocol::SERVICES },
      { name: :ipv6_4, type: Bytes, size: 16, default: Bytes[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255, 255, 0, 0, 0, 0] },
      { name: :port, type: UInt16, default: 8333_u16 },
    ]

    def address
      "#{ipv6_4[-4]}.#{ipv6_4[-3]}.#{ipv6_4[-2]}.#{ipv6_4[-1]}"
    end
  end
end
