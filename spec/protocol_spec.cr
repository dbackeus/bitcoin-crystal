require "./spec_helper"

describe Bitcoin::Protocol do
  describe ".version_message" do
    it "generates beautifully" do
      version_message = Bitcoin::Protocol.version_message("0.0.0.0", 8333, 0)

      version_message.hexdump.should match /f9 be b4 d9 76 65 72 73/

      # TODO: match the entire hexdump (how to deal with time and the nonce?)
    end
  end
end
