require 'spec_helper'

describe User do
  before { @user = User.new(name: "Example User", email: "user@example.com",
                            password: "foobar", password_confirmation: "foobar") }

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:admin) }
  it { should respond_to(:microposts) }
  it { should respond_to(:sellingbooks) }
  it { should respond_to(:wantedbooks) }

  it { should be_valid }
  it { should_not be_admin }

  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end

  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = "a"  * 51 }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com foo@bar..com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe "when password is not present" do
    before do
      @user = User.new(name: "Example User", email: "user@example.com",
                       password: " ", password_confirmation: " ")
    end
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "return value of authentcate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }

    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end

  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end

  describe "email address with mixed case" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

    it "should be saved as all lower-case" do
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email).to eq mixed_case_email.downcase
    end
  end

  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

  describe "micropost associations" do
    before { @user.save }
    let!(:older_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end

    it "should have the right microposts in the right order" do
      expect(@user.microposts.to_a).to eq [newer_micropost, older_micropost]
    end
    it "should destroy associated microposts" do
      microposts = @user.microposts.to_a
      @user.destroy
      expect(microposts).not_to be_empty
      microposts.each do |micropost|
        expect(Micropost.where(id: micropost.id)).to be_empty
      end
    end
  end

  describe "sellingbook associations" do
    before { @user.save }
    let!(:older_sellingbook) do
      FactoryGirl.create(:sellingbook, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_sellingbook) do
      FactoryGirl.create(:sellingbook, user: @user, created_at: 1.hour.ago)
    end

    it "should have the right microposts in the right order" do
      expect(@user.sellingbooks.to_a).to eq [newer_sellingbook, older_sellingbook]
    end
    it "should destroy associated microposts" do
      sellingbooks = @user.sellingbooks.to_a
      @user.destroy
      expect(sellingbooks).not_to be_empty
      sellingbooks.each do |sellingbook|
        expect(Sellingbook.where(id: sellingbook.id)).to be_empty
      end
    end

    describe "selling book" do
      let(:unfollowed_sell) do
        FactoryGirl.create(:sellingbook, user: FactoryGirl.create(:user))
      end
      its(:sell_feed) { should include(:newer_sellingbook) }
      its(:sell_feed) { should include(:older_sellingbook) }
      its(:sell_feed) { should_not include(:unfollowed_sell) }
    end
  end

  describe "wantedbook associations" do
    before { @user.save }
    let!(:older_wantedbook) do
      FactoryGirl.create(:wantedbook, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_wantedbook) do
      FactoryGirl.create(:wantedbook, user: @user, created_at: 1.hour.ago)
    end

    it "should have the right microposts in the right order" do
      expect(@user.wantedbooks.to_a).to eq [newer_wantedbook, older_wantedbook]
    end
    it "should destroy associated microposts" do
      wantedbooks = @user.wantedbooks.to_a
      @user.destroy
      expect(wantedbooks).not_to be_empty
      wantedbooks.each do |wantedbook|
        expect(Wantedbook.where(id: wantedbook.id)).to be_empty
      end
    end

    describe "wanted book" do
      let(:unfollowed_want) do
        FactoryGirl.create(:wantedbook, user: FactoryGirl.create(:user))
      end
      its(:want_feed) { should include(:newer_wantedbook) }
      its(:want_feed) { should include(:older_wantedbook) }
      its(:want_feed) { should_not include(:unfollowed_want) }
    end
  end
end