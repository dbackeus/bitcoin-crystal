require "../spec_helper"

module Bitcoin::Messages
  describe Tx do
    it "is creatable from payload" do
      message = Tx.from_payload(hexio("tx"))
      message.version.should eq 1
      message.tx_in.size.should eq 1
      message.tx_out.size.should eq 1
      message.lock_time.should eq 0

      tx_in = message.tx_in.first
      tx_in.outpoint_index.should eq 0
      tx_in.signature_script.size.should eq 73

      tx_out = message.tx_out.first
      tx_out.value.should eq 4999990000
      tx_out.pk_script.size.should eq 25
    end

    it "payload's correctly" do
      hexstring = hexstring("tx")
      message = Tx.from_payload(IO::Memory.new(hexstring.hexbytes))
      message.to_payload.to_slice.hexstring.upcase.should eq hexstring
    end

    describe "#id" do
      it "generates correctly" do
        message = Tx.from_payload(hexio("my_transaction"))

        message.id.should eq "4b2d41cb67f8c15091ac2320d84ee6fabf1f1de55eab2fb72feaf88b84226fe2"
      end
    end
  end
end
