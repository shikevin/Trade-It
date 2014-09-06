require 'spec_helper'

describe Wantedbook do

  let(:user) { FactoryGirl.create(:user) }
  before do
    @wantedbook = Wantedbook.new(content: "Math 135", user_id: user.id, active: true)
  end

  subject { @wantedbook }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:active) }
end
