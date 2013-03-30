require "spec_helper"

describe Diversion::Decode do

  # we use json encoding here but it doesn't matter as we're testing common functionality
  include_context "json"
  
  it "raise ArgumentError if data.length == 0" do
    expect{client.decode("")}.to raise_error(ArgumentError)
  end

end