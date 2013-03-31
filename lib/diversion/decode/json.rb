require 'diversion/url'
require 'diversion/signing'
require 'diversion/error/bad_url_data_format'
require 'json'
require 'active_support/core_ext/hash'

module Diversion
  module Decode
    module Json
      class << self
        def get_hash(data, options)
          arr = data.split('-')
          raise Error::BadUrlDataFormat unless arr.length.between?(1,2)

          # get json from data
          json_raw = Url::decode_url(arr.first)

          # parse the JSON and catch any error
          begin
          hash = JSON.parse(json_raw)
          rescue 
            return {:parsed => false}
          end

          # ensure hash can be accessed with strings or symbols
          hash = HashWithIndifferentAccess.new.merge(hash)

          hash[:parsed] = true # we have parsed the json

          # if signed data then extract keys and verify, else do nothing but update hash
          if arr.length == 2
            hash[:signed] = true
            hash[:key_presented] = arr[1]
            hash[:key_expected] = Signing::sign_data(options[:sign_key], options[:sign_length], json_raw)
            hash[:key_verified] = hash[:key_presented] == hash[:key_expected]
          else
            hash[:signed] = false
            hash[:key_presented] = ""
            hash[:key_expected] = ""
            hash[:key_verified] = false
          end
          hash.symbolize_keys
        end
      end
    end
  end
end