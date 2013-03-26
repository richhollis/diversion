require "spec_helper"

describe MailTrack::Encode::Json do

  include_context "json"

  it "returns correct type" do
    expect(encode_email).to be_a String
  end

  it "uses correct path" do
    expect(encode_json_html).to eq(html_json_encoded)
  end

  it "doesn't add port for 80" do
    client.port = 80
    expect(encode_json_html).to eq(html_json_encoded)
  end
  
  it "adds port number for non-80 port" do
    client.port = 81
    expect(encode_json_html).to eq(html_json_encoded({:port => 81}))
  end

  it "doesn't sign by default" do
    expect(encode_json_html).to eq(html_json_encoded)
  end

  it "signs correctly" do
    client_sign.sign_length = 32
    expect(encode_json_html_signed).to eq(html_json_encoded({:sign_length => DEFAULT_SIGN_LEN}) )
  end

  it "observes sign_length" do
    client_sign.sign_length = 2
    expect(encode_json_html_signed).to eq(html_json_encoded({:sign_length => 2}) )
  end

end