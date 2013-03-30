require "spec_helper"

describe Diversion::Client do

  it "delegates to a client" do
    expect(Diversion.encode(HTML)).to eq(html_json_encoded)
  end

  it "configures" do
    client = Diversion::Client.new
    client.configure do |c|
      c.host = "dummy.host"
    end
    expect(client.host).to eq("dummy.host")
  end

  it "allows for separate configs" do
    m1 = Diversion::Client.new({:host => "test1"})
    m2 = Diversion::Client.new({:host => "test2"})
    expect(m1.host).to_not eq(m2.host)
  end

end