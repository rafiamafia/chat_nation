class CreateChatRooms < ActiveRecord::Migration
  def change
    create_table :chat_rooms do |t|
      t.string     :title
      t.references :initiating_user
      t.boolean    :active, default: true

      t.timestamps
    end
  end
end
