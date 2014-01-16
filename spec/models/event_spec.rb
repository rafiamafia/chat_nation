require 'spec_helper'

describe Event do
  context 'validation' do
    it 'must belong to an event_type' do
      described_class.create.should_not be_valid
      described_class.create.errors.should have_key :event_type
    end

    it 'must have a chat room' do
      described_class.create.should_not be_valid
      described_class.create.errors.should have_key :chat_room
    end

    it 'must have an initiating user' do
      described_class.create.should_not be_valid
      described_class.create.errors.should have_key :initiating_user
    end

    it 'comment attribute must exist if a comment type' do
      subject = described_class.create initiating_user: User.new,
                                       chat_room: ChatRoom.new,
                                       event_type: EventType.find_by(name: 'comment')
      subject.valid?.should == false
      subject.errors.should have_key :comment
    end
  end
end
