require 'rails_helper'

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryGirl.create :user }
  let!(:user2) { FactoryGirl.create :user, username:"Kalle", password:"Barfoo1", password_confirmation:"Barfoo1" }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end
  
  describe "when exists" do
    before :each do
      user.ratings << FactoryGirl.create(:rating, beer:beer1, user:user);
      user.ratings << FactoryGirl.create(:rating2, beer:beer2, user:user);
      user2.ratings << FactoryGirl.create(:rating2, beer:beer1, user:user2);
    end

    it "are displayed on the index page" do  
      visit ratings_path         
      expect(Rating.count).to eq(3)
      expect(page).to have_content 'Number of ratings: 3'
      expect(page).to have_content 'iso 3: 10 Pekka'
      expect(page).to have_content 'Karhu: 20 Pekka'
      expect(page).to have_content 'iso 3: 20 Kalle'    
    end

    it "are displayed on their respective user page" do
      visit user_path(1)
      expect(page).to have_content 'Has made 2 ratings'
      expect(page).to have_content 'average: 15.0'
      expect(page).to have_content 'iso 3: 10'
      expect(page).to have_content 'Karhu: 20'
    end

    it "can be deleted from their respective user page" do
      visit user_path(1)
      page.first(:link, "delete").click
      
      expect(page).to have_content 'Has made 1 rating'
      expect(page).to have_content 'average: 20.0'
      expect(page).to have_content 'Karhu: 20'
     !expect(page).to_not have_content 'iso 3: 10'      
    end
  end
end
