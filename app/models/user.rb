class User < ActiveRecord::Base
  has_and_belongs_to_many :chat_rooms

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
    room.high_five_another_user self, receiving_user
  end
end
