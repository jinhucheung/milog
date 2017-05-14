require 'rails_helper'

RSpec.describe Usership, type: :model do

  let(:user) { User.create username: "aTestUser", email: "aTestUser@test.com", password: "aTestUserPsw", password_confirmation: "aTestUserPsw" }
  let(:other) { User.create username: "tTestUser", email: "tTestUser@test.com", password: "aTestUserPsw", password_confirmation: "aTestUserPsw" }  

  it "follower_id should presence" do
    expect {
      Usership.create following_id: user.id
    }.not_to change { Usership.all.reload.size }
  end

  it "following_id should presence" do
    expect {
      Usership.create follower_id: user.id
    }.not_to change { Usership.all.reload.size }
  end

  it "should create successfully with valid params" do
    expect {
      Usership.create follower_id: user.id, following_id: other.id
    }.to change { Usership.all.reload.size }.by 1
  end

  it "should create fail when follower_id and following_id are equal" do
    expect {
      us = Usership.create follower_id: user.id, following_id: user.id
      expect(us.errors.include? :follower_id).to eq true
    }.not_to change { Usership.all.reload.size }
  end

  it "should create fail when follower_id and following_id has been presence" do
    us = Usership.create follower_id: user.id, following_id: other.id
    expect {
      us = Usership.create follower_id: user.id, following_id: other.id
      expect(us.errors.include? :follower_id).to eq true
    }.not_to change { Usership.all.reload.size }   
  end

  it "user should has following" do
    expect(user.followingships.size).to eq 0
    expect(user.following.include? other).to eq false

    expect {
      user.followingships.create following_id: other.id
    }.to change { Usership.all.reload.size }.by 1

    expect(user.followingships.reload.size).to eq 1
    expect(user.following.include? other).to eq true
  end

  it "user should has followers" do
    expect(user.followerships.size).to eq 0
    expect(user.followers.include? other).to eq false

    expect{
      user.followerships.create follower_id: other.id
    }.to change { Usership.all.reload.size }.by 1

    expect(user.followerships.reload.size).to eq 1
    expect(user.followers.include? other).to eq true
  end
end