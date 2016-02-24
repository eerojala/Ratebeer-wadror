class BeerClub < ActiveRecord::Base
  has_many :memberships

  def to_s
    "#{name} (#{founded}), #{city}"
  end	

  def member_of_this_club(user)
    if user
      memberships.map do |membership|
        if (user.id == membership.user_id)
          return true
        end
      end
    end
    return false
  end
end
