module Admin::FormHelper
  def is_jpeg(url)
    url_end = url.split('.').last
    url_end[0..2] == 'jpg'
  end

  def friendly_error_message(field_name, message)
    field_name = field_name.to_s
    field_name = field_name.split('.')[1] if field_name.include? '.'
    field_name = field_name.humanize
    message << '.' unless message[message.length - 1] == '.'
    "#{field_name} #{message}"
  end
end
