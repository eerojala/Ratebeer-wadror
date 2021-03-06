class User < ActiveRecord::Base
 include RatingAverage

 has_secure_password

 validates :username, uniqueness: true,
                      length: {in: 3..15}
 validates :password, :format => {:with => /\A(?=.*[A-Z])(?=.*[0-9]).{4,}\z/, message: "must be atleast 4 characters long and include one number and one uppercase letter."}
  
 scope :frozen, -> { where denied:true }
 scope :unfrozen, -> { where denied:[nil,false] } 

 has_many :ratings, dependent: :destroy
 has_many :beers, through: :ratings
 has_many :memberships, dependent: :destroy

 def favorite_beer
   return nil if ratings.empty?
   ratings.order(score: :desc).limit(1).first.beer
 end


 def favorite_style
   favorite :style
 end
 
 def favorite_brewery
   favorite :brewery
 end

 def favorite(category)
   return nil if ratings.empty?
 
   rated = ratings.map{ |r| r.beer.send(category) }.uniq
   rated.sort_by { |item| -rating_of(category, item) }.first
 end

 def rating_of(category, item)
    ratings_of = ratings.select{ |r| r.beer.send(category)==item }
    ratings_of.map(&:score).inject(&:+) / ratings_of.count.to_f
 end

 def self.most_active(n)
   sorted_by_amount_of_ratings_in_desc_order = User.all.sort_by{ |u| -(u.ratings.count||0) }
   return sorted_by_amount_of_ratings_in_desc_order[0, n]
 end

end
