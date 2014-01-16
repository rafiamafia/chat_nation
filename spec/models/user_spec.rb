require 'spec_helper'

describe User do
  let(:user1) { described_class.create username: "newgal" }

  context 'validations' do
    it 'must have username' do
      user1.errors.should be_empty

      user = described_class.create
      user.valid?.should == false
      user.errors.should have_key :username
    end

    it 'must be unique' do
      user1.valid?.should be_true

      user2 = described_class.create username: "newgal"
      user2.valid?.should == false
      user2.errors.should have_key :username
    end
  end

  it 'can be part of many chat rooms' do
    room1 = ChatRoom.create initiating_user: user1, title: "testing"
    room2 = ChatRoom.create initiating_user: user1, title: "development"
    user1.chat_rooms.should include(room1, room2)
  end

  describe '#enter_a_chat_room' do

    it 'can enter a new chat room' do
      user2 = described_class.create username: "rubygal"
      room1 = ChatRoom.create initiating_user: user2, title: "pairing"

      STDOUT.should_receive(:puts).once
      user1.enter_a_chat_room room1
      user1.chat_rooms.should include room1
    end
  end

  describe '#leave_the_chat_room' do
    it 'can leave a room' do
      room1 = ChatRoom.create initiating_user: user1, title: "pairing"

      STDOUT.should_receive(:puts).once
      user1.leave_the_chat_room room1
      user1.chat_rooms.should_not include room1
    end
  end

  describe '#send_message' do
    it 'can send a message to another user' do
      room1 = ChatRoom.create initiating_user: user1, title: "pairing"

      STDOUT.should_receive(:puts).once
      user1.send_message room1, "hello everyone!"
    end
  end

  describe '#send_high_five_to' do
    it 'can send a message to another user' do
      user2 = described_class.create username: "rubygal"
      room1 = ChatRoom.create initiating_user: user1, title: "pairing"
      user2.enter_a_chat_room room1

      STDOUT.should_receive(:puts).once
      user1.send_high_five_to room1, user2
    end
  end
end
