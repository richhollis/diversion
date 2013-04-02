require "spec_helper"

describe Diversion::Url do

  # long enough to line break with older routines
  QUICK_BROWN_TEXT = "https://www.google.co.uk/search?q=if+%240+%3D~+%2Fgem%5Cz%2F&oq=if+%240+%3D~+%2Fgem%5Cz%2F&aqs=chrome.0.57j62l3.352&sourceid=chrome&ie=UTF-8" 
  # encoded result from 1.9.3
  QUICK_BROWN_ENCODED = Diversion::Url::escape("aHR0cHM6Ly93d3cuZ29vZ2xlLmNvLnVrL3NlYXJjaD9xPWlmKyUyNDArJTNEfislMkZnZW0lNUN6JTJGJm9xPWlmKyUyNDArJTNEfislMkZnZW0lNUN6JTJGJmFxcz1jaHJvbWUuMC41N2o2MmwzLjM1MiZzb3VyY2VpZD1jaHJvbWUmaWU9VVRGLTg=")

  # this tests our assumption that we can encode/decode as we'd expect
  it "can encode/decode URL successfully" do
    attrs = { :test => 1234, :url => 'http://somewhere.over.rainbow'}
    url = "d=#{CGI::escape(attrs.to_param)}&s=testkey"
    parsed = CGI::parse(url)
    #puts parsed
    expect(parsed.length).to eq(2)
    expect(parsed.has_key?('d')).to be_true
    expect(parsed.has_key?('s')).to be_true
    expect(parsed.has_key?('url')).to be_false
    expect(parsed.has_key?('test')).to be_false
    expect(parsed['s'].first).to eq("testkey")
    data = CGI::parse(parsed['d'].first)
    #puts data
    expect(data['test'].first).to eq("1234")
    expect(data['url'].first).to eq("http://somewhere.over.rainbow")
  end

  it "encodes correctly" do
    expect(subject.encode_url(QUICK_BROWN_TEXT)).to eq(QUICK_BROWN_ENCODED)
  end

  it "decodes correctly" do
    expect(subject.decode_url(QUICK_BROWN_ENCODED)).to eq(QUICK_BROWN_TEXT)
  end

end
