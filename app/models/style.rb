class Style < ActiveRecord::Base
  include RatingAverage

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  def to_s
    name
  end

  def self.top(n)
    sorted_by_rating_in_desc_order = Style.all.sort_by{ |s| -(s.average_rating||0) }
    return sorted_by_rating_in_desc_order[0, n]
  end
end
