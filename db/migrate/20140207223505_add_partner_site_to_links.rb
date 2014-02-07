class AddPartnerSiteToLinks < ActiveRecord::Migration
  def change
    add_column :links, :partner_site, :boolean, default: false
  end
end
