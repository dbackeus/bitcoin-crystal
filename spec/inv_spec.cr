require "./spec_helper"

module Bitcoin::Messages
  describe Inv do
    it "is creatable from payload" do
      inv = Inv.from_payload(hexio("inv"))
      inv.inventory.size.should eq 2
    end

    it "payload's correctly" do
      hexstring = hexstring("inv")
      inv = Inv.from_payload(IO::Memory.new(hexstring.hexbytes))
      inv.payload.to_slice.hexstring.upcase.should eq hexstring
    end
  end
end
