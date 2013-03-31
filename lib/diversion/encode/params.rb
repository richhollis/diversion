module Diversion
  module Encode
    module Params
      class << self
        def get_url(attrs, options)
          # if we are signing the url then generate the signature
          sig = Signing::sign_data(options[:sign_key], options[:sign_length], attrs.to_param)
          sig_param = ""
          unless sig.empty?
            sig_param = "&s=#{sig}"
          end

          params = CGI::escape(attrs.to_param)

          # get url and include port if needed
          unless options[:port] == 80
            url = "#{options[:host]}:#{options[:port]}#{options[:path]}?d=#{params}#{sig_param}"
          else
            url = "#{options[:host]}#{options[:path]}?d=#{params}#{sig_param}"
          end
          url
        end
      end
    end
  end
end