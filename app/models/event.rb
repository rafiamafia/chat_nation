class Event < ActiveRecord::Base
  validates :event_type, :chat_room, :initiating_user, presence: true
  validates :comment, presence: true, if: :comment_type?

  belongs_to :initiating_user, class_name: 'User'
  belongs_to :receiving_user, class_name: 'User'
  belongs_to :event_type
  belongs_to :chat_room

  def comment_type?
    self.event_type == EventType.find_by(name: "comment")
  end
end
