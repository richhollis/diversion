require "spec_helper"

describe "Test Url Encoding" do

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

end
