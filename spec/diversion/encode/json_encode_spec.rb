require "spec_helper"

describe Diversion::Encode::Json do

  include_context "json"

  it "returns correct type" do
    expect(encode_email).to be_a String
  end

  it "uses correct path" do
    expect(encode_json_html).to match(/http:\/\/localhost.domain\/redirect\/1\/[A-Za-z0-9].*\">test<\/a>/)
  end

  it "doesn't add port for 80" do
    client.port = 80
    expect(encode_json_html).to_not match(/http:\/\/localhost.domain:80\/redirect/)
  end
  
  it "adds port number for non-80 port" do
    client.port = 81
    expect(encode_json_html).to match(/http:\/\/localhost.domain:81\/redirect/)
  end

  it "doesn't sign by default" do
    expect(encode_json_html).to_not match(/-/)
  end

  it "signs correctly" do
    client_sign.sign_length = 32
    expect(encode_json_html_signed).to match(/-[A-Za-z0-9]{32}\"/)
  end

  it "observes sign_length" do
    client_sign.sign_length = 2
    expect(encode_json_html_signed).to match(/-[A-Za-z0-9]{2}\"/)
  end

end