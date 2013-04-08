require 'diversion/encode/json'
require 'diversion/encode/params'
require 'diversion/error/uri_missing_error'
require 'nokogiri'

module Diversion
  module Encode
    include Base64
    include Signing
    include Json

    ENCODERS = [ Params, Json ]

    def encode(html, global_attrs = {}, opts = {})
      opts = options.merge(opts)
      validate_configuration!

      raise Error::UriMissingError if opts[:encode_uris].count == 0
      doc = Nokogiri::HTML.fragment(html)
      doc.search('a').each do |link|
        # ignore any non web uris
        next unless link[:href].start_with?(*opts[:encode_uris].collect{|uri| "#{uri}:"})

        # data attributes
        attrs = {}

        # gather data- attributes from all links
        link.attributes.each do |attr|
          name = attr[0]
          value = attr[1].value
          if name.start_with?('data-') 
            data_name = name[5..-1]
            attrs[data_name] = value
            # remove current attribute from the document
            link.remove_attribute(name)
          end
        end

        # set the url
        attrs["url"] = link[:href]

        # merge in any global attributes
        attrs = attrs.merge(global_attrs)

        # get url for required type
        url = opts[:url_encoding].get_url(attrs, opts)
        url = doc_escape(url)
        link["href"] = url
      end
      # work around Nokogiri escaping of & and replace with intended ampersands
      doc_unescape(doc.to_html)
    end

    private

    def doc_escape(str)
      str.gsub(/&/, "$myamp;")
    end

    def doc_unescape(str)
      # 1st gsub - work around Nokogiri escaping of & and replace with intended ampersands
      # 2nd gsub - address issue with jruby (presume slightly different output from Nokogiri on jruby)
      str.gsub(/%24myamp;/, "&").gsub(/\$myamp;/, "&")
    end

  end
end