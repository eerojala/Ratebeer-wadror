class User < ActiveRecord::Base
 include RatingAverage

 has_secure_password

 validates :username, uniqueness: true,
                      length: {in: 3..15}
 validates :password, :format => {:with => /\A(?=.*[A-Z])(?=.*[0-9]).{4,}\z/, message: "must be atleast 4 characters long and include one number and one uppercase letter."}

 has_many :ratings, dependent: :destroy
 has_many :beers, through: :ratings
 has_many :memberships, dependent: :destroy

 def favorite_beer
   return nil if ratings.empty?
   ratings.order(score: :desc).limit(1).first.beer
 end

end