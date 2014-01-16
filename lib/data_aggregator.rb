class DataAggregator
  include GranualityLevel

  ActiveRecord::Base.logger = nil

  #Data aggregation method - input takes chatroom and granuality level
  #TODO: user should have access to the chat room
  def self.group_by(chat_room, granuality_level)
    puts granuality_level

    case granuality_level
    when GranualityLevel::MINUTE
      events_by_granuality = self.group_events_by chat_room, "beginning_of_minute", '%I:%M %p'
      puts basic_presenter(events_by_granuality)
    else
      events_by_granuality = self.group_events_by chat_room, "beginning_of_hour", '%I %p'
      puts presenter(events_by_granuality)
    end
  end

  private

  def self.set_sql_logger(level=nil)
    ActiveRecord::Base.logger = level
  end

  define_singleton_method(:group_events_by) do |chat_room, granuality, strformat|
    Event.where(chat_room: chat_room).group_by do |event|
      event.created_at.send(granuality).strftime(strformat)
    end
  end

  def self.presenter(events_by_granuality, aggregated_data = "")
    events_by_granuality.map do |time, event_by_granuality|
      events_by_type = event_by_granuality.group_by { |event| [type: event.event_type.name, description: event.event_type.description] }
      aggregated_data = "#{time}: "
      events_by_type.map do |event_type, events|
        case event_type.first[:type]
        when "high_five"
          event_description = event_type.first[:description].split(" : ").last
          aggregated_data = aggregated_data + high_five_event_presenter(events, event_description)
        when "enter"
          aggregated_data = aggregated_data + "#{events.count} #{ events.count > 1 ? 'people' : 'person' } #{event_type.first[:description].split(" : ").last}\n"
        else
          aggregated_data = aggregated_data + "#{events.count} #{event_type.first[:description].split(" : ").last}\n"
        end
      end
    end
    aggregated_data
  end

  def self.basic_presenter(events_by_granuality, aggregated_data = "")
    events_by_granuality.map do |time, events|
      events.map do |event|
        aggregated_data = aggregated_data + "#{time}: #{event.initiating_user.username} #{event.event_type.description.split(" : ").first}" +
                            (event.event_type == EventType.find_by(name: 'comment') ? ": '#{event.comment}'" :
                              event.event_type == EventType.find_by(name: 'high_five') ? " #{event.receiving_user.username}" : '') + "\n"
      end
    end
    aggregated_data
  end

  def self.high_five_event_presenter(events, description)
    sets = events.group_by { |event| [event.initiating_user_id, event.receiving_user_id] }.keys
    initiating_user_count = sets.map(&:first).uniq.count
    receiving_user_count  = sets.map(&:last).uniq.count

    "#{initiating_user_count} #{initiating_user_count > 1 ? 'people' : 'person'} " +
      description + " #{receiving_user_count} other #{receiving_user_count > 1 ? 'people' : 'person'}\n"
  end

end
