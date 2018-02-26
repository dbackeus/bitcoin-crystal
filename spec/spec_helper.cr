require "spec"
require "../src/bitcoin"

def hexstring(filename)
  File.read("spec/fixtures/#{filename}.hex").gsub(/\s/, "")
end

def hexio(filename)
  IO::Memory.new(hexstring(filename).hexbytes)
end
