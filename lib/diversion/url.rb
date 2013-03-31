require "base64"

module Diversion
  module Url

    class << self
    
      def encode_url(url)
        Base64.urlsafe_encode64(url).gsub('=',',')
      end

      def decode_url(url)
       Base64.urlsafe_decode64(url.gsub(',','='))
      end

    end

  end
end
