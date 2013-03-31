require 'spec_helper'

class ConfigTestStub
  include Diversion::Configurable
end

describe Diversion::Configurable do

  let(:config) { config = ConfigTestStub.new; config.reset!; config }

  def set_config(&block) config.configure do |c| c.instance_eval(&block) end; end
  def host(value); set_config{|c|c.host = value}; end
  def path(value); set_config{|c|c.path = value}; end
  def port(value); set_config{|c|c.port = value}; end
  def encode_uris(value); set_config{|c|c.encode_uris = value}; end
  def sign_length(value); set_config{|c|c.sign_length = value}; end
  def url_encoding(value); set_config{|c|c.url_encoding = value}; end
  def url_decoding(value); set_config{|c|c.url_decoding = value}; end

  describe "host" do
    it "must be a string" do
      expect{host(1)}.to raise_error
    end
    it "accepts string type" do
      expect{host('test')}.to_not raise_error
    end
    it "cannot end with trailing slash" do
      expect{host('test/')}.to raise_error
    end
    it "doesnt accept nil" do
      expect{host(nil)}.to raise_error
    end
  end

  describe "path" do
    it "must be a string" do
      expect{path(1)}.to raise_error
    end
    it "accepts string type" do
      expect{path('test/')}.to_not raise_error
    end
    it "must end with trailing slash" do
      expect{path('test')}.to raise_error
    end
    it "doesnt accept nil" do
      expect{path(nil)}.to raise_error
    end
  end

  describe "port" do
    it "must be an integer" do
      expect{port('test')}.to raise_error
    end
    it "accepts an integer" do
      expect{port(1)}.to_not raise_error
    end
    it "does not accept 0" do
      expect{port(0)}.to raise_error
    end
    it "does not accept <0" do
      expect{port(-1)}.to raise_error
    end
    it "doesnt accept nil" do
      expect{port(nil)}.to raise_error
    end
  end

  describe "sign_length" do
    it "must be an integer" do
      expect{sign_length('test')}.to raise_error
    end
    it "accepts 0 (disaled)" do
      expect{sign_length(0)}.to_not raise_error
    end
    it "accepts integer at lower range" do
      expect{sign_length(1)}.to_not raise_error
    end
    it "accepts integer at higher range" do
      expect{sign_length(Diversion::Signing::MAX_SIGN_LENGTH)}.to_not raise_error
    end
    it "does not accept <0" do
      expect{sign_length(-1)}.to raise_error
    end
    it "doesnt accept nil" do
      expect{sign_length(nil)}.to raise_error
    end
  end

  describe "encode_uris" do
    it "must be an array" do
      expect{encode_uris('test')}.to raise_error
    end
    it "accepts uri" do
      expect{encode_uris(['http'])}.to_not raise_error
    end
    it "doesnt accept nil" do
      expect{encode_uris(nil)}.to raise_error
    end
    it "doesnt accept empty array" do
      expect{encode_uris([])}.to raise_error
    end
  end

  describe "url_encoding" do
    it "must be a module" do
      expect{url_encoding('test')}.to raise_error
    end
    it "accepts a valid module" do
      expect{url_encoding(Diversion::Encode::Json)}.to_not raise_error
    end
    it "doesn't accept an invalid module" do
      expect{url_encoding(Diversion::Decode::Json)}.to raise_error
    end
  end

  describe "url_decoding" do
    it "must be a module" do
      expect{url_decoding('test')}.to raise_error
    end
    it "accepts a valid module" do
      expect{url_decoding(Diversion::Decode::Json)}.to_not raise_error
    end
    it "doesn't accept an invalid module" do
      expect{url_decoding(Diversion::Encode::Json)}.to raise_error
    end
  end

end