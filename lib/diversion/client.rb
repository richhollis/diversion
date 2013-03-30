require 'diversion/configurable'
require 'diversion/encode'
require 'diversion/decode'

module Diversion

  class Client

    include Configurable
    include Encode
    include Decode

    def initialize(options={})
      Diversion::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", options[key] || Diversion.instance_variable_get(:"@#{key}"))
      end
    end

  end

end