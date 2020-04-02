module SharesHelper
  def show_embedded_share(url)
    require 'onebox'
    begin
      preview = Onebox.preview(url)
      preview.to_s == '' ? share_url_as_link(url) : preview.to_s
    rescue
      share_url_as_link(url)
    end
  end

  def share_url_as_link(url)
    link_to url, url
  end
end
