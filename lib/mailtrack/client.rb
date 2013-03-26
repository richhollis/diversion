require 'mailtrack/configurable'
require 'mailtrack/encode'
require 'mailtrack/decode'

module MailTrack

  class Client

    include Configurable
    include Encode
    include Decode

    def initialize(options={})
      MailTrack::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", options[key] || MailTrack.instance_variable_get(:"@#{key}"))
      end
    end

  end

end