require 'spec_helper'

describe DataAggregator do
  describe '.group_by' do
    let(:user) { User.create username: "rubygal" }
    let(:room) { ChatRoom.create title: "testing", initiating_user: user }

    it 'takes a chat_room and granuality_level' do
      described_class.should_receive(:group_by).with(room, GranularityLevel::MINUTE)
      DataAggregator.group_by room, GranularityLevel::MINUTE
    end

    context 'presentation of data aggregation' do
      context 'GranularityLevel::MINUTE' do
      end

      context 'GranularityLevel::HOUR' do
      end

      context 'GranularityLevel::DAY' do
      end

      context 'GranularityLevel::WEEK' do
      end
      context 'GranularityLevel::MONTH' do
      end

      context 'GranularityLevel::YEAR' do
      end
    end
  end
end
