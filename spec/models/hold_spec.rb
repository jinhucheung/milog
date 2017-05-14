require 'rails_helper'

RSpec.describe Hold, type: :model do 
  let(:user) { User.create username: "aTestUser", email: "aTestUser@test.com", password: "aTestUserPsw", password_confirmation: "aTestUserPsw" }

  it "should create with user_id and holdable_type" do
    expect {
      user.holds.create holdable_type: 'Article'
    }.to change { user.holds.reload.size }.by 1
  end

  it "should not create without user_id" do
    expect {
      Hold.create holdable_type: 'Article'
    }.not_to change { Hold.all.reload.size }
  end

  it "should not create without holdable_type" do
    user.save
    expect {
      user.holds.create 
    }.not_to change { Hold.all.reload.size }
  end

  it "holdable_type must equal Article or Resume" do
    h = user.holds.create holdable_type: 'Test'
    expect(h.errors.include? :holdable_type).to eq true
    h = user.holds.create holdable_type: '123456'
    expect(h.errors.include? :holdable_type).to eq true
    h = user.holds.create holdable_type: 'Article'
    expect(h.valid?).to eq true
    h = user.holds.create holdable_type: 'Resume'
    expect(h.valid?).to eq true
  end


end 