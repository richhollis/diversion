require 'spec_helper'

describe Mail::Message do

  it "replaces html part" do
    msg = Mail::Message.new(fixture('sample_email.multipart').read).diversion
    expect(msg.html_part.body).to include('<a href="localhost.domain/redirect/1/?d=url%3Dhttp%253A%252F%252Fwww.youtube.com%252Fwatch%253Fv%253DFE_9CzLCbkY">Dream of the 90s</a>')
    expect(msg.html_part.body).to include('<a href="localhost.domain/redirect/1/?d=url%3Dhttp%253A%252F%252Fwww.youtube.com%252Fwatch%253Fv%253DOyQ6pqPFwTI">Customers only</a>')
  end

end