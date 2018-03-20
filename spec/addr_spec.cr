require "./spec_helper"

module Bitcoin::Messages
  describe Addr do
    it "is creatable from payload" do
      addr = Addr.from_payload(hexio("addr"))
      addr.addr_list.size.should eq 1
      addr.addr_list.first.address.should eq "10.0.0.1"
    end

    it "payload's correctly" do
      hexstring = hexstring("addr")
      addr = Addr.from_payload(IO::Memory.new(hexstring.hexbytes))
      addr.to_payload.to_slice.hexstring.upcase.should eq hexstring
    end
  end
end
