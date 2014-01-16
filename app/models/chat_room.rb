class ChatRoom < ActiveRecord::Base
  after_save :enter_the_room
  validates :title, presence: true, uniqueness: true
  validates :initiating_user, presence: true

  has_many :events
  has_and_belongs_to_many :users
  belongs_to :initiating_user, class_name: "User"

  #EventType.all.each do |event_type|
  #  define_method(event_type.name) do |user, params={}|
  #    if self.users.include?
  #      puts "#{Time.now.strftime('%H:%M%P')}: #{user.username} #{event_type.description}"
  #      event = Event.create initiating_user: user, event_type: event_type
  #      self.events << event
  #  else
  #    invalid_user_error user
  #  end
  #end

  def enter_the_room(user = self.initiating_user)
    if !self.users.include? user
      puts "#{Time.now.strftime('%H:%M%P')}: #{user.username} enters the room"
      event = Event.create initiating_user: user, event_type: event_type('enter')
      self.events << event
      self.users << user
    else
      Rails.logger.error "#{user.username} is already in chatroom #{self.title}"
    end
  end

  def leave_the_room(user)
    if self.users.include? user
      puts "#{Time.now.strftime('%H:%M%P')}: #{user.username} leaves"
      event = Event.create initiating_user: user, event_type: event_type('leave')
      self.events << event
      self.users.delete user
    else
      invalid_user_error user
    end
  end

  def comment(user, comment)
    if self.users.include? user
      puts "#{Time.now.strftime('%H:%M%P')}: #{user.username} comments: \"#{comment}\""
      event = Event.create initiating_user: user, event_type: event_type('comment'), comment: comment
      self.events << event
    else
      invalid_user_error user
    end
  end

  def high_five_another_user(from, to)
    if self.users.include?(from)
      if self.users.include?(to)
        puts "#{Time.now.strftime('%H:%M%P')}: #{from.username} high-fives #{to.username}"
        event = Event.create initiating_user: from, receiving_user: to, event_type: event_type('high_five')
        self.events << event
      else
        invalid_user_error to
      end
    else
      invalid_user_error from
    end
  end

  private

  def event_type(name)
    EventType.find_by(name: name)
  end

  def invalid_user_error(user)
    Rails.logger.error "#{from.username} is not an authorized user in chatroom #{self.title}"
  end
end
