require 'spec_helper'

describe ChatRoom do
  context 'validation' do

    it 'must have a title' do
      described_class.create.valid?.should == false
    end

    it 'must have a unique title' do
      room1 = described_class.create title: "room1", initiating_user: User.create
      room2 = described_class.create title: "room1", initiating_user: User.create

      room2.should_not be_valid
      room2.errors.should have_key :title
    end

    it 'must be created by a user' do
      room = described_class.create title: "emptyroom"
      room.should_not be_valid
      room.errors.should have_key :initiating_user
    end
  end

  context 'chat room events' do
  end

  describe '#enter_the_room' do
    let(:user1)    { User.create(username: "user1") }
    let(:subject)  { described_class.create title: "emptyroom",
                                            initiating_user: user1 }
    let(:event_type) { EventType.find_by(name: "enter") }

    it 'lets a new user enter the room' do
      user2 = User.create(username: "user2")

      subject.enter_the_room user2
      user2.chat_rooms.include? subject
    end

    it 'creates an enter event upon success' do
      subject.events.last.event_type.should == event_type
    end

    it 'errors out if user is already in the room' do
      Rails.logger.should_receive(:error)
      subject.enter_the_room user1
    end
  end

  describe '#leave_the_room' do
    let(:user1)    { User.create(username: "user1") }
    let(:subject)  { described_class.create title: "emptyroom", initiating_user: user1 }
    let(:event_type) { EventType.find_by(name: "leave") }

    it 'lets the current user leave the room' do
      subject.leave_the_room user1
      user1.chat_rooms.should be_empty
    end

    it 'creates a leave event' do
      subject.leave_the_room user1
      subject.events.last.event_type.should == event_type
    end

    it 'errors out if user is not the room' do
      user2 = User.create(username: "user2")

      Rails.logger.should_receive(:error)
      subject.leave_the_room user2
    end
  end

  describe '#comment' do
    let(:user1)      { User.create(username: "user1") }
    let(:subject)    { described_class.create title: "emptyroom", initiating_user: user1 }
    let(:event_type) { EventType.find_by(name: "comment") }

    it 'lets the current user make a comment' do
      STDOUT.should_receive("puts").twice #with if TimeCop
      subject.comment user1, "some goofy comment"
    end

    it 'creates a comment event' do
      subject.comment user1, "some goofy comment"
      subject.events.last.event_type.should == event_type
    end

    it 'errors out if user is not the room' do
      user2 = User.create(username: "user2")

      Rails.logger.should_receive(:error)
      subject.comment user2, "oops!"
    end
  end

  describe '#high_five_another_user' do
    let(:user1)      { User.create(username: "user1") }
    let(:user2)      { User.create(username: "user2") }
    let(:subject)    { described_class.create title: "emptyroom", initiating_user: user1 }
    let(:event_type) { EventType.find_by(name: "high_five") }

    it 'lets one user high_five another user' do
      user2.enter_a_chat_room subject
      subject.high_five_another_user user1, user2
      subject.events.last.event_type.should == event_type
    end

    it 'errors out if receiving_user is not in the room' do
      Rails.logger.should_receive(:error)

      user2.chat_rooms.should be_empty
      subject.high_five_another_user user1, user2
    end

    it 'errors out if user does not have access to the chat room' do
      Rails.logger.should_receive(:error)

      user2.chat_rooms.should be_empty
      subject.high_five_another_user user2, user1
    end
  end
end
