module MailTrack
  module Configurable
    extend Forwardable
    attr_accessor :host, :port, :path, :sign_key, :sign_length, :encode_uris
    attr_accessor :url_encoding, :url_decoding
    def_delegator :options, :hash

    class << self

      def keys
        @keys ||= [
          :host,
          :port,
          :path,
          :sign_key,
          :sign_length,
          :encode_uris,
          :url_encoding,
          :url_decoding
        ]
      end

    end

    def configure
      yield self
      self
    end

    def reset!
      @host = 'localhost.domain'
      @port = 80
      @path = '/redirect/1/'
      @sign_length = 0
      @encode_uris = ['http','https']
      @url_encoding = Encode::Json
      @url_decoding = Decode::Json
      self
    end
    alias setup reset!

    private

    # @return [Hash]
    def options
      Hash[MailTrack::Configurable.keys.map{|key| [key, instance_variable_get(:"@#{key}")]}]
    end

  end
end
