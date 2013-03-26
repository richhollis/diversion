require 'mailtrack/encode/json'
require 'mailtrack/encode/params'
require 'mailtrack/helper'
require 'nokogiri'

module MailTrack

  class UriMissingError < StandardError; end

  module Encode
    include Helper
    include Json

    def encode(html, global_attrs = {}, opts = {})
      opts = options.merge(opts)
      raise UriMissingError if opts[:encode_uris].count == 0
      doc = Nokogiri::HTML.fragment(html)
      doc.search('a').each do |link|
        # ignore any non web uris
        next unless link[:href].start_with?(*encode_uris)

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
        url = url.gsub(/&/, "$myamp;") # as Nokogiri encodes & to &amp; which breaks our urls we gotta hack this
        link["href"] = url
      end
      doc.to_html.gsub(/%24myamp;/, "&") # work around Nokogiri escaping of & and replace with intended ampersands
    end

  end

end