require "spec_helper"

describe MailTrack::Decode::Json do

  include_context "json"

  it "returns correct type for non-signed" do
    expect(decode_json).to be_a Hash
  end

  it "returns correct type for signed" do
    expect(decode_json_signed).to be_a Hash
  end

  it "raises when data format invalid" do
    expect{client.decode("test-test-test")}.to raise_error(MailTrack::BadUrlDataFormat)
  end

  it "doesn't parse when passed bad data" do
    expect(client.decode("test-test")[:parsed]).to be_false
  end

  it "parses when passed good data" do
    expect(decode_json[:parsed]).to be_true
  end

  it "returns expected values when passed good unsigned data" do
    hash = decode_json
    expect(hash[:url]).to eq("http://test.com/test")
    expect(hash[:signed]).to be_false
    expect(hash[:key_presented]).to be_empty
    expect(hash[:key_expected]).to be_empty
    expect(hash[:key_verified]).to be_false
  end

  it "returns expected values when passed good signed data" do
    hash = decode_json_signed
    expect(hash[:url]).to eq("http://test.com/test")
    expect(hash[:signed]).to be_true
    expect(hash[:key_presented]).to eq(JSON_KEY)
    expect(hash[:key_expected]).to eq(JSON_KEY)
    expect(hash[:key_verified]).to be_true
  end

  it "returns expected values when passed badly signed data" do
    hash = decode_json_bad_key
    expect(hash[:url]).to eq("http://test.com/test")
    expect(hash[:signed]).to be_true
    expect(hash[:key_presented]).to eq(JSON_KEY_BAD)
    expect(hash[:key_expected]).to eq(JSON_KEY)
    expect(hash[:key_verified]).to be_false
  end

  it "decodes parameters as expected" do
    enc = client.encode(HTML, {:b => 999})
    data = enc.scan(/".*?\/.*?\/.*?\/(.*?)"/).first.first
    result = client.decode(data)
    expect(result[:test]).to eq("1234")
    expect(result[:b]).to eq(999)
  end

  it "decodes parameters as expected when signed" do
    enc = client_sign.encode(HTML, {:b => 999})
    data = enc.scan(/".*?\/.*?\/.*?\/(.*?)"/).first.first
    hash = client.decode(data)
    expect(hash[:test]).to eq("1234")
    expect(hash[:b]).to eq(999)
  end

end