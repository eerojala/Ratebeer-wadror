require 'rails_helper'

RSpec.describe Beer, type: :model do
  before :each do
    @style = FactoryGirl.create(:style)
  end

  it "is saved with a name and style" do
    beer = Beer.create name:"test", style: @style

    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end

  it "is not saved without a name" do
    beer = Beer.create style: @style
    
    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "is not saved without a style" do																																																												
    beer = Beer.create name:"test"
    
    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end
end
