require 'mailtrack/decode/json'
require 'mailtrack/decode/params'

module MailTrack

  class BadUrlDataFormat < StandardError; end

  module Decode
    include Helper

    def decode(data, opts = {})
      raise ArgumentError if data.length == 0

      opts = options.merge(opts)

      # get hash for required type
      hash = opts[:url_decoding].get_hash(data, opts)
    end

  end

end