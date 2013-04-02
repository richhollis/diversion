require "base64"

module Diversion
  module Url

    class << self
    
      def encode_url(str)
        str = legacy_encode(str) if RUBY_VERSION < "1.9"
        str = Base64.urlsafe_encode64(str) if RUBY_VERSION >= "1.9"
        escape(str)
      end

      def decode_url(str)
        str = legacy_decode(unescape(str)) if RUBY_VERSION < "1.9"
        str = Base64.urlsafe_decode64(unescape(str)) if RUBY_VERSION >= "1.9"
        str
      end

      # :nocov:   (turns on skip lines mode)
      if RUBY_VERSION < "1.9"
        def legacy_encode(str)
          Base64.encode64(str).gsub(/\n/,"")
        end

        def legacy_decode(str)
          Base64.decode64(str)
        end
      end
      # :nocov:   (turns off skip lines mode)

      def escape(str)
        str.gsub('=',',')
      end

      def unescape(str)
        str.gsub(',','=')
      end

    end

  end
end
