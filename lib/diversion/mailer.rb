require 'mail'

Mail::Message.class_eval do
  def diversion(*args)
    if html_part
      html_part.body = Diversion.encode(html_part.body.raw_source)
    end
    self
  end
end