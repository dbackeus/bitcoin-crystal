require "../spec_helper"

module Bitcoin::Messages
  describe Block do
    it "is creatable from payload" do
      block = Block.from_payload(hexio("block"))

      block.version.should eq 536870912
      block.previous_block_header_hash.should eq Bytes[166, 131, 128, 149, 166, 136, 199, 26, 92, 119, 222, 101, 143, 60, 225, 183, 198, 154, 114, 77, 239, 253, 161, 96, 54, 155, 203, 82, 0, 0, 0, 0]
      block.merkle_root_hash.should eq  Bytes[55, 155, 216, 110, 98, 190, 231, 18, 223, 202, 179, 75, 56, 149, 37, 238, 106, 95, 198, 229, 149, 249, 243, 190, 164, 1, 130, 38, 131, 249, 7, 154]
      block.time.should eq 1522071073_u32
      block.bits.should eq 486604799_u32
      block.nonce.should eq 805616841_u32
      block.txns.size.should eq 669

      my_transaction = block.txns[335]
      my_transaction.version.should eq 1
      my_transaction.tx_in.size.should eq 1
      my_transaction.tx_out.size.should eq 2
      my_transaction.lock_time.should eq 0

      tx_in = my_transaction.tx_in.first
      tx_in.outpoint_index.should eq 1_u32
      tx_in.signature_script.size.should eq 23

      tx_out1 = my_transaction.tx_out[0]
      tx_out1.value.should eq 65000000_i64
      tx_out1.pk_script.size.should eq 25

      tx_out2 = my_transaction.tx_out[1]
      tx_out2.value.should eq 5154538314_i64
      tx_out2.pk_script.size.should eq 23
    end

    it "payload's correctly" do
      hexstring = hexstring("block")
      block = Block.from_payload(IO::Memory.new(hexstring.hexbytes))

      block.to_payload.to_slice.hexstring.should eq hexstring
    end

    describe "#id" do
      it "generates correctly" do
        message = Block.from_payload(hexio("block"))

        message.id.should eq "00000000000ed3597c86730bcc829b6b2c602113e4e6438ff0b1162cf58258bc"
      end
    end
  end
end
