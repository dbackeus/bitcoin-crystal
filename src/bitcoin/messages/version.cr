module Bitcoin::Messages
  class Version
    def self.from_payload(io : IO)
      version = io.read_bytes(Int32)
      services = io.read_bytes(UInt64)
      timestamp = io.read_bytes(Int64)
      addr_recv_services = io.read_bytes(UInt64)
      addr_recv_ip = io.read_string(16).to_slice
      addr_recv_port = io.read_bytes(UInt16)
      addr_trans_services = io.read_bytes(UInt64)
      addr_trans_ip = io.read_string(16).to_slice
      addr_trans_port = io.read_bytes(UInt16)
      nonce = io.read_bytes(UInt64)
      user_agent_size = Bitcoin::Protocol.read_var_int(io)
      user_agent = io.read_string(user_agent_size)
      start_height = io.read_bytes(Int32)

      new(
        version: version,
        services: services,
        timestamp: timestamp,
        addr_recv_services: addr_recv_services,
        addr_recv_ip: addr_recv_ip,
        addr_recv_port: addr_recv_port,
        addr_trans_services: addr_trans_services,
        addr_trans_ip: addr_trans_ip,
        addr_trans_port: addr_trans_port,
        nonce: nonce,
        user_agent: user_agent,
        start_height: start_height,
      )
    end

    getter :version
    getter :services
    getter :timestamp
    getter :addr_recv_services
    getter :addr_recv_ip
    getter :addr_recv_port
    getter :addr_trans_services
    getter :addr_trans_ip
    getter :addr_trans_port
    getter :nonce
    getter :user_agent
    getter :start_height

    def initialize(
      @version : Int32,
      @services : UInt64,
      @timestamp : Int64,
      @addr_recv_services : UInt64,
      @addr_recv_ip : Bytes,
      @addr_recv_port : UInt16,
      @addr_trans_services : UInt64,
      @addr_trans_ip : Bytes,
      @addr_trans_port : UInt16,
      @nonce : UInt64,
      @user_agent : String,
      @start_height : Int32,
      )
    end

    def to_payload : IO
      IO::Memory.new.tap do |io|
        io.write_bytes(@version)
        io.write_bytes(@services)
        io.write_bytes(@time)
        io.write_bytes(@addr_recv_services)
        io.write(@addr_recv_ip)
        io.write_bytes(@addr_recv_port)
        io.write_bytes(@addr_trans_services)
        io.write(@addr_trans_ip)
        io.write_bytes(@addr_trans_port)
        io.write_bytes(@nonce)
        io.write_byte(@user_agent.size.to_u8)
        io.write(@user_agent.to_slice)
        io.write_bytes(@start_height)
      end
    end

    def inspect
      "Version #{@version}\nServices #{@services}\nStart height #{start_height}"
    end
  end
end
