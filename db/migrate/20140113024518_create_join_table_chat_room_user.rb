class CreateJoinTableChatRoomUser < ActiveRecord::Migration
  def change
    create_join_table :chat_rooms, :users do |t|
      t.index [:chat_room_id, :user_id]
      t.index [:user_id, :chat_room_id]
    end
  end
end
