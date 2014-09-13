require 'spec_helper'

describe "TradePages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "sellingbook creation" do
    before { visit root_path }

    describe "with invalid information " do

      it "should not create a sellingbook" do
        expect { click_button "Sell" }.not_to change(Sellingbook, :count)
      end

      describe "error messages" do
        before { click_button "Sell" }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do

      before { fill_in 'sellingbook_content', with: "Math 135" }
      it "should create a sellingbook" do
        expect { click_button "Sell" }.to change(Sellingbook, :count).by(1)
      end
    end
  end
  describe "wantedbook creation" do
    before { visit root_path }

    describe "with invalid information " do

      it "should not create a wantedbook" do
        expect { click_button "Want" }.not_to change(Wantedbook, :count)
      end

      describe "error messages" do
        before { click_button "Want" }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do

      before { fill_in 'wantedbook_content', with: "Math 135" }
      it "should create a wantedbook" do
        expect { click_button "Want" }.to change(Wantedbook, :count).by(1)
      end
    end
  end
end