require 'spec_helper'

describe Mail::Message do

  let(:multipart) { Mail::Message.new(fixture('sample_email.multipart').read).diversion }
  let(:multipart_args) { Mail::Message.new(fixture('sample_email.multipart').read).diversion({:a => 1}, {:encode_uris => ['http']}) }
  let(:text_only) { Mail::Message.new(fixture('sample_email.text').read).diversion }

  it "replaces html part" do
    expect(multipart.html_part.body).to include('<a href="http://localhost.domain/redirect/1/?d=url%3Dhttp%253A%252F%252Fwww.youtube.com%252Fwatch%253Fv%253DFE_9CzLCbkY">Dream of the 90s</a>')
    expect(multipart.html_part.body).to include('<a href="http://localhost.domain/redirect/1/?d=url%3Dhttps%253A%252F%252Fwww.youtube.com%252Fwatch%253Fv%253DOyQ6pqPFwTI">Customers only</a>')
  end

  it "doesn't replace text part" do
    expect(text_only.body).to include('http://www.youtube.com/watch?v=FE_9CzLCbkY')
    expect(text_only.body).to include('http://www.youtube.com/watch?v=OyQ6pqPFwTI')
  end

  it "doesn't fail when only text part present" do
    expect{text_only}.to_not raise_error
  end

  it "honors additional global data parameters" do
    expect(multipart_args.html_part.body).to include('<a href="http://localhost.domain/redirect/1/?d=a%3D1%26url%3Dhttp%253A%252F%252Fwww.youtube.com%252Fwatch%253Fv%253DFE_9CzLCbkY">Dream of the 90s</a>')
  end

  it "honors additional config arguments" do
    expect(multipart_args.html_part.body).to include('<a href="https://www.youtube.com/watch?v=OyQ6pqPFwTI">Customers only</a>')
  end

end