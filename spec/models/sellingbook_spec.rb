require 'spec_helper'

describe Sellingbook do

  let(:user) { FactoryGirl.create(:user) }
  before { @sellingbook = user.sellingbooks.build(content: "Math 135", active: true) }

  subject { @sellingbook }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:active) }
  it { should respond_to(:user) }
  its(:user) { should eq user }

  it { should be_valid }

  describe "when user_id is not present" do
    before { @sellingbook.user_id = nil }
    it { should_not be_valid }
  end

  describe "with blank content" do
    before { @sellingbook.content = " " }
    it {  should_not be_valid }
  end

  describe "with content that is too long" do
    before { @sellingbook.content = "a" * 141 }
    it { should_not be_valid }
  end
end
