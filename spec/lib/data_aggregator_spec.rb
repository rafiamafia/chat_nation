require 'spec_helper'

describe DataAggregator do
  describe '.group_by' do
    let(:user) { User.create username: "rubygal" }
    let(:room) { ChatRoom.create title: "testing", initiating_user: user }

    it 'takes a chat_room and granuality_level' do
      described_class.should_receive(:group_by).with(room, GranualityLevel::MINUTE)
      DataAggregator.group_by room, GranualityLevel::MINUTE
    end
  end
end
