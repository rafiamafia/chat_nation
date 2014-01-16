class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :initiating_user, index: true
      t.references :receiving_user, index: true
      t.references :event_type, index: true
      t.references :chat_room, index: true
      t.text :comment

      t.timestamps
    end
  end
end
