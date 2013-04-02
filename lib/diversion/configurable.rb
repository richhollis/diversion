require 'forwardable'
require 'diversion/error/configuration_error'

module Diversion
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
      validate_configuration!
      self
    end

    def reset!
      @host = 'http://localhost.domain'
      @port = 80
      @path = '/redirect/1/'
      @sign_length = 0
      @encode_uris = ['http','https']
      @url_encoding = Encode::Params
      @url_decoding = Decode::Params
      validate_configuration!
      self
    end
    alias setup reset!

    private

    # @return [Hash]
    def options
      Hash[Diversion::Configurable.keys.map{|key| [key, instance_variable_get(:"@#{key}")]}]
    end

    # Ensures that all configuration parameters are of an expected type. 
    #
    # @raise [Diversion::Error::ConfigurationError] Error is raised when
    #   supplied configuration is not of expected type
    def validate_configuration!
      unless @host.is_a?(String) && @host.length > 0
        raise(Error::ConfigurationError, "Invalid host specified: Host must contain the host to redirect to.")
      end
      if @host.end_with?('/')
        raise(Error::ConfigurationError, "Invalid host specified: #{@host} should not end with a trailing slash.")
      end

      unless @path.is_a?(String) && @path.length > 0
        raise(Error::ConfigurationError, "Invalid path specified: Path must contain a path to redirect to.")
      end
      unless @path.end_with?('/')
        raise(Error::ConfigurationError, "Invalid path specified: #{@path} should end with a trailing slash.")
      end

      unless @port.is_a?(Integer) && @port > 0
        raise(Error::ConfigurationError, "Invalid port specified: #{@port} must be an integer and non-zero.")
      end

      unless @sign_length.is_a?(Integer) && @sign_length.between?(0, Signing::MAX_SIGN_LENGTH)
        raise(Error::ConfigurationError, "Invalid sign_length specified: #{@sign_length} must be an integer between 0-#{Signing::MAX_SIGN_LENGTH}.")
      end

      unless @encode_uris.is_a?(Array) && @encode_uris.count > 0
        raise(Error::ConfigurationError, "Invalid encode_uris specified: #{@encode_uris} must be an array with at least one URI scheme.")
      end

      unless @url_encoding.is_a?(Module) && Encode::ENCODERS.include?(@url_encoding)
        raise(Error::ConfigurationError, "Invalid url_encoding specified: #{@url_encoding} must be a valid encoder module.")
      end

      unless @url_decoding.is_a?(Module) && Decode::DECODERS.include?(@url_decoding)
        raise(Error::ConfigurationError, "Invalid url_decoding specified: #{@url_decoding} must be a valid decoder module.")
      end
    end

  end
end
