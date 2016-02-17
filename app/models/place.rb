class Place
  include ActiveModel::Model
  attr_accessor :id, :name, :status, :reviewlink, :proxylink, :blogmap, :street, :city, :state, :zip, :country, :phone, :overall, :imagecount
  
  def self.rendered_fields
    [:id, :name, :status, :street, :city, :zip, :country, :overall]
  end

  def map_url
    url = blogmap
    if Rails.env == "development"
      url
    else
      url.insert(4, 's:')
    end
  end
end
