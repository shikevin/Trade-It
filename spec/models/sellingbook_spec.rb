require 'spec_helper'

describe Sellingbook do

  let(:user) { FactoryGirl.create(:user) }
  before do
    @sellingbook = Sellingbook.new(content: "Math 135", user_id: user.id, active: true)
  end

  subject { @sellingbook }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:active) }
end
