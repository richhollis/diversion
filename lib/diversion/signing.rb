require 'diversion/error/key_missing_error'
require 'hmac-md5'

module Diversion
  module Signing

    MAX_SIGN_LENGTH = 32

    def self.sign_data(sign_key, sign_length, data)
      sig = ""
      unless sign_length == 0
        raise Error::KeyMissingError.new unless sign_key
        sig = HMAC::MD5.new(sign_key).update(data).hexdigest[0..sign_length-1]
      end
      sig
    end

  end
end
