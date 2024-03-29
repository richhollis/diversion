def use_json 
  { :url_encoding => Diversion::Encode::Json, :url_decoding => Diversion::Decode::Json }
end

def use_params
  { :url_encoding => Diversion::Encode::Params, :url_decoding => Diversion::Decode::Params }
end

shared_context 'json' do
  let(:client) { @client ||= Diversion::Client.new(use_json) }
  let(:client_sign) { @client ||= Diversion::Client.new(use_json.merge({:sign_length => 32, :sign_key => SIGN_KEY})) }
  let(:encode_email) { @email = client.encode(fixture('mail.html').read, {:a => 1}) }
  let(:encode_json_html) { client.encode(HTML) }
  let(:encode_json_html_signed) { client_sign.encode(HTML) }
  let(:decode_json) { client.decode(JSON_ENCODED) }
  let(:decode_json_signed) { client_sign.decode(JSON_ENCODED_SIGNED) }
  let(:decode_json_bad_key) { client_sign.decode(JSON_ENCODED_SIGNED_KEY_BAD) }
end

shared_context 'params' do
  let(:client) { Diversion::Client.new(use_params) }
  let(:client_sign) { Diversion::Client.new(use_params.merge({:sign_length => 32, :sign_key => SIGN_KEY})) }
  let(:encode_email) { @email = client.encode(fixture('mail.html').read, {:a => 1}) }
  let(:encode_params_html) { client.encode(HTML) }
  let(:encode_params_html_signed) { client_sign.encode(HTML) }
  let(:decode_params) { client.decode(PARAMS_ENCODED) }
  let(:decode_params_signed) { client_sign.decode(PARAMS_ENCODED_SIGNED) }
  let(:decode_params_bad_key) { client_sign.decode(PARAMS_ENCODED_SIGNED_KEY_BAD) }
end