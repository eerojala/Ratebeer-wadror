require 'rails_helper'

include Helpers

describe "Beers page" do
  describe "creating a beer" do
    before :each do
      FactoryGirl.create(:brewery)
      FactoryGirl.create(:brewery, name: 'brewery', year: 2001)
      FactoryGirl.create(:style)
      FactoryGirl.create(:style, name: 'IPA', description: "Another test")
      FactoryGirl.create(:user)
      sign_in(username:"Pekka", password:"Foobar1")
      visit new_beer_path
    end

    it "is successful with valid parameters" do
      fill_in('beer_name', with:'Kalia')
      select('IPA', from:'beer[style_id]')
      select('brewery', from:'beer[brewery_id]')

      expect{
        click_button "Create Beer"
      }.to change{Beer.count}.from(0).to(1)
      
      expect(page).to have_content 'Beer was successfully created.'
      expect(page).to have_content 'Kalia'
    end

   it "is unsuccessful with an invalid name" do
      select('Lager', from:'beer[style_id]')
      select('brewery', from:'beer[brewery_id]')
      click_button('Create Beer')

      expect(Beer.count).to eq(0)
      expect(page).to have_content "Name can't be blank"
    
   end
  end
end
