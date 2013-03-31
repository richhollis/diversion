require 'diversion/decode/json'
require 'diversion/decode/params'

module Diversion
  module Decode
    include Base64
    include Signing

    DECODERS = [ Params, Json ]

    def decode(data, opts = {})
      raise ArgumentError if data.length == 0

      opts = options.merge(opts)

      # get hash for required type
      hash = opts[:url_decoding].get_hash(data, opts)
    end

  end
end