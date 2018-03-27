require "../spec_helper"

module Bitcoin::Messages
  describe Getblocks do
    it "is creatable from payload" do
      getblocks = Getblocks.from_payload(hexio("getblocks"))
      getblocks.block_header_hashes.size.should eq 2
    end

    it "payload's correctly" do
      hexstring = hexstring("getblocks")
      getblocks = Getblocks.from_payload(IO::Memory.new(hexstring.hexbytes))
      getblocks.to_payload.to_slice.hexstring.upcase.should eq hexstring
    end
  end
end
