require 'mail'

Mail::Message.class_eval do
  def diversion(*args)
    if html_part
      html_part.body = Diversion.encode(html_part.body.raw_source.encode("UTF-8"), *args) if RUBY_VERSION >= "1.9"
      html_part.body = Diversion.encode(html_part.body.raw_source, *args) if RUBY_VERSION < "1.9"
    end
    self
  end
end