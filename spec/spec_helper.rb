require 'simplecov'
SimpleCov.start do
  add_group 'Libraries', 'lib'
  add_group 'Spec', 'spec'
end

require "mailtrack"
require 'support/global_shared_context'

SIGN_KEY = "abcdefghijklmnopqrstuvwzxy"

HTML = '<a data-test="1234" href="http://test.com/test">test</a>'
HTML_ATTRIBS = { :test => 1234, :url => 'http://test.com/test'}

DEFAULT_SIGN_LEN = 32
KEY_BAD = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'

#json
JSON_ENCODED = 'eyJ0ZXN0IjoiMTIzNCIsInVybCI6Imh0dHA6Ly90ZXN0LmNvbS90ZXN0In0,'
JSON_HTML = "<a href=\"localhost.domain/redirect/1/#{JSON_ENCODED}\">test</a>"
JSON_KEY = '9755dfdf3353860cc6a33867c21482e3'
JSON_KEY_BAD = KEY_BAD
JSON_ENCODED_SIGNED = "#{JSON_ENCODED}-#{JSON_KEY}"
JSON_ENCODED_SIGNED_KEY_BAD = "#{JSON_ENCODED}-#{JSON_KEY_BAD}"

# params
PARAMS_KEY = '6b18e4b2864ab25c7fde6116eb942080'
PARAMS_KEY_BAD = KEY_BAD
PARAMS_ENCODED = "d=#{CGI::escape(HTML_ATTRIBS.to_param)}"
PARAMS_ENCODED_SIGNED = "#{PARAMS_ENCODED}&s=6b18e4b2864ab25c7fde6116eb942080"
PARAMS_ENCODED_SIGNED_KEY_BAD = "#{PARAMS_ENCODED}&s=#{PARAMS_KEY_BAD}"



RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  config.color_enabled = true
end

def fixture_path
  File.expand_path("../fixtures", __FILE__)
end

def fixture(file)
  File.new(fixture_path + '/' + file)
end

def sample_default_opts
  { :port => 80, :sign_length => 0 }
end

def html_json_encoded(opts = {})
  opts = sample_default_opts.merge(opts)
  key = ""
  unless opts[:sign_length] == 0
    key = "-#{JSON_KEY[0..opts[:sign_length]-1]}"
  end
  return "<a href=\"localhost.domain/redirect/1/#{JSON_ENCODED}#{key}\">test</a>" if opts[:port] == 80
  "<a href=\"localhost.domain:#{opts[:port]}/redirect/1/#{JSON_ENCODED}#{key}\">test</a>"
end

def html_params_encoded(opts = {})
  opts = sample_default_opts.merge(opts)
  if opts[:sign_length] == 0 
    path = PARAMS_ENCODED 
  else 
    path = PARAMS_ENCODED_SIGNED
    key = "#{PARAMS_KEY[0..opts[:sign_length]-1]}"
    path = path.gsub(PARAMS_KEY, key)
  end
  return "<a href=\"localhost.domain/redirect/1/?#{path}\">test</a>" if opts[:port] == 80
  "<a href=\"localhost.domain:#{opts[:port]}/redirect/1/?#{path}\">test</a>"
end