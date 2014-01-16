if EventType.all.empty?
  #event description contains the present and past tense of data aggregation level
  EventType.create name: "enter", description: 'enters the room : entered'
  EventType.create name: "leave", description: 'leaves : left'
  EventType.create name: "comment", description: 'comments : commented'
  EventType.create name: "high_five", description: 'high-fives : high-fived'

  u1 = User.create username: "Rafia"
  u2 = User.create username: "Dan"
  u3 = User.create username: "Bob"
  u4 = User.create username: "Kate"

  #assignment test data
  c1 = ChatRoom.create title: "nation builder", initiating_user: User.find_by(username: "Bob")
  sleep 1.minute
  c2 = ChatRoom.create title: "food for thoughts", initiating_user: User.find_by(username: "Dan")
  sleep 1.minute
  c1.enter_the_room u4
  sleep 1.minute
  u3.send_message(c1, "Hey, Kate - high five?")
  sleep 1.minute
  u4.send_high_five_to c1, u3
  sleep 1.minute
  u3.leave_the_chat_room c1
  sleep 1.minute
  u4.send_message(c1, "Oh, typical")
  sleep 1.minute
  u4.leave_the_chat_room c1
end
