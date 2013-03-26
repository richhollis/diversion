require "spec_helper"

describe MailTrack::Encode do

  # we use json encoding here but it doesn't matter as we're testing common functionality
  include_context "json"
  
  it "ignores non-http uris" do
    expect(encode_email).to include('mailto:jess@doesnotexist.domain')
  end

  it "converts http uris" do
    expect(encode_email).to_not include('https://twitter.com/intent/tweet?in_reply_to=51113028241989632')
  end

  it "removes data attributes" do
    expect(encode_email).to_not include('data-')
  end

  it "raises when signing key not set" do
    client_sign.sign_key = nil
    expect { encode_json_html_signed }.to raise_error(MailTrack::KeyMissingError)
  end

  it "raises when no uris defined" do
    client.encode_uris = []
    expect { encode_json_html_signed }.to raise_error(MailTrack::UriMissingError)
  end

end