# Diversion Ruby Gem

[![Gem Version](https://badge.fury.io/rb/diversion.png)][gem]
[![Build Status](https://secure.travis-ci.org/richhollis/diversion.png?branch=master)][travis]
[![Dependency Status](https://gemnasium.com/richhollis/diversion.png?travis)][gemnasium]
[![Coverage Status](https://coveralls.io/repos/richhollis/diversion/badge.png?branch=master)][coveralls]

[gem]: https://rubygems.org/gems/diversion
[travis]: http://travis-ci.org/richhollis/diversion
[gemnasium]: https://gemnasium.com/richhollis/diversion
[coveralls]: https://coveralls.io/r/richhollis/diversion

Redirect HTML links through your preferred redirection URL

Diversion aims are simple - to be a framework agnostic way to redirect all URLs via another path whilst leaving the original URL intact, leaving you to perform the actual implementation of the redirection logic. 

Link redirection is particularly desirable for some Rails mailers where you want to track a link click first before redirecting the user to the original link.

Diversion was created specifically with a Rails use case in mind but can be used without Rails/ActionMailer. 

A Rails mailer helper is provided if you are using ActionMailer. 

## Installation

    gem install diversion

To ensure the code you're installing hasn't been tampered with, it's recommended that you verify the signature. To do this, you need to add my public key as a trusted certificate (you only need to do this once):

    gem cert --add <(curl -Ls https://gist.github.com/richhollis/5301656/raw/richhollis.pem)

Then, install the gem with the high security trust policy:

    gem install twitter -P HighSecurity    

Add this line to your application's Gemfile:

    gem 'diversion'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install diversion

## Quick Start Guide & Example

Configure your redirection settings:

```ruby
Diversion.configure do |config|
  config.host = 'http://localhost.domain'
  config.path = '/redirect/'
end
```

Example usage:

Encode takes an HTML body and encodes all anchor links to the new redirection location. 

You can specifiy additional parameters for each url by using a "data-" attribute, for example:

```html
<a data-from="welcome_email" href="http://www.youtube.com/watch?v=feeA-Dr0XGw">Portlandia Intro</a>
```

The data-from attribute will be added to the encoded parameters and will be available when the URL is decoded.

```ruby
Diversion::encode('<a data-from="welcome_email" href="http://www.youtube.com/watch?v=feeA-Dr0XGw">Portlandia Intro</a>') 
# => "<a href=\"http://localhost.domain/redirect/1/?d=from%3Dwelcome_email%26url%3Dhttp%253A%252F%252Fwww.youtube.com%252Fwatch%253Fv%253DfeeA-Dr0XGw\">Portlandia Intro</a>"
```

Then to get the original data (this might be in say your Redirect controller) we parse the parameters of the URL:

```ruby
Diversion::decode('d=from%3Dwelcome_email%26url%3Dhttp%253A%252F%252Fwww.youtube.com%252Fwatch%253Fv%253DfeeA-Dr0XGw')
# => {:key_presented=>"", :parsed=>true, :signed=>false, :key_expected=>"", :key_verified=>false, :from=>"welcome_email", :url=>"http://www.youtube.com/watch?v=feeA-Dr0XGw"} 
```

## Global data parameters

You can specify parameters that should be present for all encoded URLs. This might typically be an ID or something similar. 
Specify these parameters in the second parameter to the encode (or diversion mailer) method with a hash of the parameters you wish to add. 

Example:

```ruby
Diversion::encode('<a data-from="welcome_email" href="http://www.youtube.com/watch?v=feeA-Dr0XGw">Portlandia Intro</a>', {:id => 1} )
# =>  => "<a href=\"http://localhost.domain/redirect/1/?d=from%3Dwelcome_email%26id%3D1%26url%3Dhttp%253A%252F%252Fwww.youtube.com%252Fwatch%253Fv%253DfeeA-Dr0XGw\">Portlandia Intro</a>"
```

## Overriding configuration parameters

You can the global configuration by specifying a third parameter to encode (or diversion mailer) with a hash of the parameters you wish to override.

Example:

```ruby
Diversion::encode('<a data-from="welcome_email" href="http://www.youtube.com/watch?v=feeA-Dr0XGw">Portlandia Intro</a>', {:id => 1}, {:encode_uris => ['https']} )
# => "<a data-from=\"welcome_email\" href=\"http://www.youtube.com/watch?v=feeA-Dr0XGw\">Portlandia Intro</a>" 
```

Note: Because we've overridden the encode_uris setting to only encode https urls our URL hasn't been redirected.

## Enabling Url 'Signing'

You can 'sign' the url which works by appending a parameter with a hash of the URL. The hash can be as long as 32 characters. When you enable signing, but setting the sign_length configuration option you can choose between 0-32, where 0 is disabled. The hash is generated using HMAC::MD5.

```ruby
Diversion.configure do |config|
  config.sign_length = 2
  config.sign_key = 'yoursecretkey'
end
```

## Changing the Encoding Method

The default encoding method is query string parameters (Encode::Params/Decode::Params). This can be changed for JSON if you wish (Encode::Json/Decode::Json).

```ruby
Diversion.configure do |config|
  config.url_encoding = Encode::Json
  config.url_decoding = Decode::Json
end
```

## Rails Mailer Example

app/views/test_mailer/welcome_email.html.erb:

```html
<p>Hey</p>

<p>Click on the following link to view some great content:</p>

<a data-type="video" href="http://www.youtube.com/watch?v=feeA-Dr0XGw">Portlandia</a>
```

app/mailers/test_mailer.rb:

```ruby
class TestMailer < ActionMailer::Base
  default from: "from@example.com"

  def welcome_email
    # Note: we're adding a global parameter user_id - this is optional
    mail(:to => 'somebody@no.where', :subject => "Welcome to My Awesome Site").diversion({:user_id => 1})
  end
end
```

Note: Remember you can also add global parameters and override config options buy passing these to the diversion helper too - e.g.

```ruby
mail(:to => 'somebody@no.where', :subject => "Welcome to My Awesome Site").diversion({:user_id => 1}, {:encode_uris => ['http']} )
```

app/controllers/redirect_controller.rb:

```ruby
class RedirectController < ApplicationController

  respond_to :html

  def show
    hash = Diversion::decode(request.query_string)

    # do something with parameters hash like save request in database

    # output parameters
    render :text => hash

    # or redirect
    # redirect_to(hash[:url])
  end

end
```

Sample Redirect Controller output:

{:key_presented=>"", :parsed=>true, :signed=>false, :key_expected=>"", :key_verified=>false, :from=>"welcome_email", :url=>"http://www.youtube.com/watch?v=feeA-Dr0XGw", :user_id => 1}

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Provide tests for the changes
6. Create new Pull Request
