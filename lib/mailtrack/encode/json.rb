require 'mailtrack/helper'
require 'json'

module MailTrack
  module Encode
    module Json
      class << self
        def get_url(attrs, options)
          # raw json
          json_raw = attrs.to_json

          # build json (slightly lighter than ruby hash)
          json = Helper::base64_encode_url(json_raw)

          # if we are signing the url then generate the signature
          sig = Helper::sign_data(options[:sign_key], options[:sign_length], json_raw)
          sig = "-#{sig}" unless sig.empty?

          # get url and include port if needed
          unless options[:port] == 80
            url = "#{options[:host]}:#{options[:port]}#{options[:path]}#{json}#{sig}"
          else
            url = "#{options[:host]}#{options[:path]}#{json}#{sig}"
          end
        end
      end
    end
  end
end