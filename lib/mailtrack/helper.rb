require "base64"
require 'hmac-md5'

module MailTrack

  class KeyMissingError < StandardError; end
  
  module Helper

    def self.base64_encode_url(url)
      Base64.urlsafe_encode64(url).gsub('=',',')
    end

    def self.base64_decode_url(url)
      Base64.urlsafe_decode64(url.gsub(',','='))
    end

    def self.sign_data(sign_key, sign_length, data)
      sig = ""
      unless sign_length == 0
        raise KeyMissingError.new unless sign_key
        sig = HMAC::MD5.new(sign_key).update(data).hexdigest[0..sign_length-1]
      end
      sig
    end

  end
end
