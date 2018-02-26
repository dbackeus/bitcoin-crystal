module Bitcoin::Messages
  class Version < Message
    payload [
      { name: :version, type: Int32, default: Bitcoin::Protocol::VERSION },
      { name: :services, type: UInt64, default: Bitcoin::Protocol::SERVICES },
      { name: :timestamp, type: UInt64, default: Time.now.epoch },
      { name: :addr_recv_services, type: UInt64, default: Bitcoin::Protocol::SERVICES },
      { name: :addr_recv_ip, type: Bytes, size: 16, default: Bytes[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255, 255, 0, 0, 0, 0] },
      { name: :addr_recv_port, type: UInt16, default: 8333_u16 },
      { name: :addr_trans_services, type: UInt64, default: Bitcoin::Protocol::SERVICES },
      { name: :addr_trans_ip, type: Bytes, size: 16, default: Bytes[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255, 255, 0, 0, 0, 0] },
      { name: :addr_trans_port, type: UInt16, default: 8333_u16 },
      { name: :nonce, type: UInt64, default: Bitcoin::Protocol::NONCE },
      { name: :user_agent, type: String, size: :var_int, default: Bitcoin::Protocol::USER_AGENT },
      { name: :start_height, type: Int32, default: 0_i32 },
    ]

    def inspect
      "Version #{@version}\nServices #{@services}\nStart height #{start_height}"
    end
  end
end
