require "../spec_helper"

module Bitcoin::Structures
  describe BlockHeader do
    it "is creatable from payload" do
      structure = BlockHeader.from_payload(hexio("block_header"))
      structure.version.should eq 2
      structure.previous_block_header_hash.hexstring.should eq "b6ff0b1b1680a2862a30ca44d346d9e8910d334beb48ca0c0000000000000000"
      structure.merkle_root_hash.hexstring.should eq "9d10aa52ee949386ca9385695f04ede270dda20810decd12bc9b048aaab31471"
      structure.time.should eq 1415239972
      structure.bits.should eq 404472624 # TODO: handle the nbits value properly?
      structure.nonce.should eq 1678286846
    end

    it "payload's correctly" do
      hexstring = hexstring("block_header")
      blockheader = BlockHeader.from_payload(IO::Memory.new(hexstring.hexbytes))
      blockheader.to_payload.to_slice.hexstring.upcase.should eq hexstring
    end
  end
end
