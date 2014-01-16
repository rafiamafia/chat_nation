class Event < ActiveRecord::Base
  validates :event_type, :chat_room, :initiating_user, presence: true

  belongs_to :initiating_user, class_name: 'User'
  belongs_to :receiving_user, class_name: 'User'
  belongs_to :event_type
  belongs_to :chat_room
end
