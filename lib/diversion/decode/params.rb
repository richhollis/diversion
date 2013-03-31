require 'diversion/signing'
require 'diversion/error/bad_url_data_format'
require 'active_support/core_ext/hash'
require 'active_support/core_ext/object' # to_param

module Diversion
  module Decode
    module Params
      class << self
        def get_hash(params, options)
          # ensure hash can be accessed with strings or symbols
          hash = HashWithIndifferentAccess.new.merge(CGI::parse(params))

          # validate expected parameters are present (d)
          raise Error::BadUrlDataFormat.new('Missing data parameter') unless hash.include?('d')

          # d is holding the url and data attributes
          params = CGI::parse(CGI::unescape(hash["d"].first))
          params_escaped = hash["d"].first

          # remove array from parsed hash, taking the first item
          params.each do |k,v|
            params[k] = v.first
          end
          hash.delete(:d)

          # ensure url provided or raise
          raise Error::BadUrlDataFormat.new('Missing url parameter') if !params.include?('url') or params["url"].empty?
          
          # s is holding the signature (if provided)
          hash[:key_presented] = ""
          if hash.has_key?(:s)
            hash[:key_presented] = hash[:s].first
            hash.delete(:s)
          end

          hash[:parsed] = true

          # if signed data then extract keys and verify, else do nothing but update hash
          unless hash[:key_presented].empty?
            hash[:signed] = true
            hash[:key_expected] = Signing::sign_data(options[:sign_key], options[:sign_length], params_escaped)
            hash[:key_verified] = hash[:key_presented] == hash[:key_expected]
          else
            hash[:signed] = false
            hash[:key_expected] = ""
            hash[:key_verified] = false
          end

          hash = hash.merge(params.symbolize_keys).symbolize_keys
        end
      end
    end
  end
end