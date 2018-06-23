module Admin::FormHelper
  def is_jpeg(url)
    url_end = url.split('.').last
    url_end[0..2] == 'jpg'
  end
end
