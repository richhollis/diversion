shared_context 'json' do
  let(:client) { @client ||= MailTrack::Client.new }
  let(:client_sign) { @client ||= MailTrack::Client.new({:sign_length => 32, :sign_key => SIGN_KEY}) }
  let(:encode_email) { @email = client.encode(fixture('mail.html').read, {:a => 1}) }
  let(:encode_json_html) { client.encode(HTML) }
  let(:encode_json_html_signed) { client_sign.encode(HTML) }
  let(:decode_json) { client.decode(JSON_ENCODED) }
  let(:decode_json_signed) { client_sign.decode(JSON_ENCODED_SIGNED) }
  let(:decode_json_bad_key) { client_sign.decode(JSON_ENCODED_SIGNED_KEY_BAD) }
end

shared_context 'params' do
  let(:client) { MailTrack::Client.new({:url_encoding => MailTrack::Encode::Params, :url_decoding => MailTrack::Decode::Params}) }
  let(:client_sign) { MailTrack::Client.new({:url_encoding => MailTrack::Encode::Params, :url_decoding => MailTrack::Decode::Params, :sign_length => 32, :sign_key => SIGN_KEY}) }
  let(:encode_email) { @email = client.encode(fixture('mail.html').read, {:a => 1}) }
  let(:encode_params_html) { client.encode(HTML) }
  let(:encode_params_html_signed) { client_sign.encode(HTML) }
  let(:decode_params) { client.decode(PARAMS_ENCODED) }
  let(:decode_params_signed) { client_sign.decode(PARAMS_ENCODED_SIGNED) }
  let(:decode_params_bad_key) { client_sign.decode(PARAMS_ENCODED_SIGNED_KEY_BAD) }
end