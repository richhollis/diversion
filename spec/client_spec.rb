require "spec_helper"

describe MailTrack::Client do

  it "delegates to a client" do
    expect(MailTrack.encode(HTML)).to eq(html_json_encoded)
  end

  it "configures" do
    client = MailTrack::Client.new
    client.configure do |c|
      c.host = "dummy.host"
    end
    expect(client.host).to eq("dummy.host")
  end

  it "allows for separate configs" do
    m1 = MailTrack::Client.new({:host => "test1"})
    m2 = MailTrack::Client.new({:host => "test2"})
    expect(m1.host).to_not eq(m2.host)
  end

end