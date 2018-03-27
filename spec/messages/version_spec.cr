require "../spec_helper"

module Bitcoin::Messages
  describe Version do
    it "is creatable from payload" do
      version = Version.from_payload(hexio("version"))
      version.version.should eq 60002
    end

    it "payload's correctly" do
      hexstring = hexstring("version")
      version = Version.from_payload(IO::Memory.new(hexstring.hexbytes))
      version.to_payload.to_slice.hexstring.upcase.should eq hexstring
    end

    describe "#command" do
      it "is version" do
        Version.new.command.should eq "version"
      end
    end
  end
end
