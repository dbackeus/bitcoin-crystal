UI for converting private -> public -> address:
https://bitcore.io/playground/#/address

Maybe helpful cli examples of openssl generating keys:
https://bitcoin.stackexchange.com/questions/59644/how-do-these-openssl-commands-create-a-bitcoin-private-key-from-a-ecdsa-keypair

http://www.righto.com/2014/02/bitcoins-hard-way-using-raw-bitcoin.html

Generate wallet keys:
https://www.bitaddress.org
https://www.bitaddress.org?testnet=true

How to download (sync) blockchain:
https://en.bitcoin.it/wiki/Block_chain_download
(see the "Catchup Case" examples under Analysis)

High level description of wallets:
https://bitcoin.org/en/developer-guide#wallets

locator_hashes = ["00000000c93472dce4fbb69571790ed2ebbcf78d3b7af4dace5239412150a4d1"]
DEFAULT_STOP_HASH = "0000000000000000000000000000000000000000000000000000000000000000"

def self.locator_payload(version, locator_hashes, stop_hash)
  [
    [version].pack("V"),
    pack_var_int(locator_hashes.size),
    locator_hashes.map{|l| l.htb_reverse }.join,
    stop_hash.htb_reverse
  ].join
end

def self.getblocks_pkt(version, locator_hashes, stop_hash=DEFAULT_STOP_HASH)
  pkt "getblocks",  locator_payload(version, locator_hashes, stop_hash)
end
