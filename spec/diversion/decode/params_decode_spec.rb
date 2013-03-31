require "spec_helper"

describe Diversion::Decode::Params do

  include_context "params"

  it "returns correct type for non-signed" do
    expect(decode_params).to be_a Hash
  end

  it "returns correct type for signed" do
    expect(decode_params_signed).to be_a Hash
  end

  it "raises when data format invalid" do
   expect{client.decode("badparam=badvalue")}.to raise_error(Diversion::Error::BadUrlDataFormat)
  end

  it "raises when data format invalid" do
   expect{client.decode("rubbish")}.to raise_error(Diversion::Error::BadUrlDataFormat)
  end

  it "raises when missing url data parameter" do
    expect{client.decode("d=#{CGI::escape('badparam=badvalue')}")}.to raise_error(Diversion::Error::BadUrlDataFormat)
  end

  it "raises when missing url data parameter empty" do
    expect{client.decode("d=#{CGI::escape('url=')}")}.to raise_error(Diversion::Error::BadUrlDataFormat)
  end

  it "returns expected values when passed good unsigned data" do
    hash = decode_params
    expect(hash[:url]).to eq("http://test.com/test")
    expect(hash[:signed]).to be_false
    expect(hash[:key_presented]).to be_empty
    expect(hash[:key_expected]).to be_empty
    expect(hash[:key_verified]).to be_false
  end

  it "returns expected values when passed good signed data" do
    hash = decode_params_signed
    expect(hash[:url]).to eq("http://test.com/test")
    expect(hash[:signed]).to be_true
    expect(hash[:key_presented]).to eq(PARAMS_KEY)
    expect(hash[:key_expected]).to eq(PARAMS_KEY)
    expect(hash[:key_verified]).to be_true
  end

  it "returns expected values when passed badly signed data" do
    hash = decode_params_bad_key
    expect(hash[:url]).to eq("http://test.com/test")
    expect(hash[:signed]).to be_true
    expect(hash[:key_presented]).to eq(PARAMS_KEY_BAD)
    expect(hash[:key_expected]).to eq(PARAMS_KEY)
    expect(hash[:key_verified]).to be_false
  end

  it "decodes parameters as expected" do
    enc = client.encode(HTML, {:b => 999})
    data = enc.scan(/".*?\/.*?\/.*?\/(.*?)"/).first.first[1..-1]
    result = client.decode(data)
    expect(result[:test]).to eq("1234")
    expect(result[:b]).to eq("999")
  end

  it "decodes parameters as expected when signed" do
    enc = client_sign.encode(HTML, {:b => 999})
    data = enc.scan(/".*?\/.*?\/.*?\/(.*?)"/).first.first[1..-1]
    hash = client.decode(data)
    expect(hash[:test]).to eq("1234")
    expect(hash[:b]).to eq("999")
  end

end