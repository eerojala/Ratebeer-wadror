class Membership < ActiveRecord::Base
 validates_uniqueness_of :user_id, :scope => :beer_club_id
 validates_uniqueness_of :beer_club_id, :scope => :user_id

 belongs_to :user
 belongs_to :beer_club
end
