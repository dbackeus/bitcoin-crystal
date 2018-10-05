# secp256k1_ec_pubkey_create

@[Link("secp256k1")]

lib LibSecp256k1
  struct Secp256k1Context
    ecmult_ctx : secp256k1_ecmult_context
    ecmult_gen_ctx : secp256k1_ecmult_gen_context
    illegal_callback : secp256k1_callback
    error_callback : secp256k1_callback
  end

  fun secp256k1_ec_pubkey_create(
    secp256k1_context : Secp256k1Context*,
    secp256k1_pubkey : Int32*,
    private_key : UInt8
  ) : Int32

  fun secp256k1_context_create(flags : UInt32) : Secp256k1Context*

  fun secp256k1_context_destroy(context : Secp256k1Context*)

  # struct secp256k1_pubkey
  #   data: UInt8[64] # char data[64];
  # end
  #
  # struct secp256k1_ecdsa_signature
  #   data: UInt8[64] # char data[64];
  # end
  #
  # struct secp256k1_context_struct {
  #   secp256k1_ecmult_context ecmult_ctx;
  #   secp256k1_ecmult_gen_context ecmult_gen_ctx;
  #   secp256k1_callback illegal_callback;
  #   secp256k1_callback error_callback;
  # };
end

secp256k1_context = 1
secp256k1_pubkey = 1

LibSecp256k1.secp256k1_ec_pubkey_create(pointerof(secp256k1_context), pointerof(secp256k1_pubkey), 1_u8)
