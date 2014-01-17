class User < ActiveRecord::Base
  include DataAggregator

  has_and_belongs_to_many :chat_rooms
  has_many :friendships
  has_many :friends, :through => :friendships

  validates :username, presence: true, uniqueness: true

  def enter_a_chat_room(room)
    room.enter_the_room self
  end

  def leave_the_chat_room(room)
    room.leave_the_room self
  end

  def send_message(room, msg)
    room.comment self, msg
  end

  def send_high_five_to(room, receiving_user)
    room.high_five_another_user(self, receiving_user)
    add_friend receiving_user
    receiving_user.add_friend self
  end

  def add_friend(user)
    self.friends << user
  end

  def aggregate_data_by(room, granularity_level)
    if self.chat_rooms.include? room
      DataAggregator.group_by room, granularity_level
    else
      Rails.logger.error "#{self.username} does not have access to #{room.title}"
    end
  end
end
