module DataAggregator
  ActiveRecord::Base.logger = nil

  def self.group_by(chat_room, granularity_level)
    begin
      puts granularity_level

      case granularity_level
      when GranularityLevel::MINUTE
        events_by_granuality = self.group_events_by chat_room, "beginning_of_minute", '%I:%M %p'
        puts minimal_presenter(events_by_granuality)
      when GranularityLevel::HOUR
        events_by_granuality = self.group_events_by chat_room, "beginning_of_hour", '%I %p'
        puts presenter(events_by_granuality)
      when GranularityLevel::DAY
        events_by_granuality = self.group_events_by chat_room, "beginning_of_day", '%D'
        puts presenter(events_by_granuality)
      when GranularityLevel::WEEK
        events_by_granuality = self.group_events_by chat_room, "beginning_of_week", 'year: %Y week: %w'
        puts presenter(events_by_granuality)
      when GranularityLevel::MONTH
        events_by_granuality = self.group_events_by chat_room, "beginning_of_month", 'year: %Y month: %m'
        puts presenter(events_by_granuality)
      when GranularityLevel::YEAR
        events_by_granuality = self.group_events_by chat_room, "beginning_of_hour", '%Y'
        puts presenter(events_by_granuality)
      end
    rescue Exception => e
      Rails.logger.error "There is an error with aggregating data for #{chat_room.inspec}. Error: #{e.inspect}"
    end
  end

  private

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
          aggregated_data = aggregated_data + "#{events.count} #{people_text_presenter(events.count)} #{event_type.first[:description].split(" : ").last}\n"
        else
          aggregated_data = aggregated_data + "#{events.count} #{event_type.first[:description].split(" : ").last}\n"
        end
      end
    end
    aggregated_data
  end

  def self.minimal_presenter(events_by_granuality, aggregated_data = "")
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
    #group by uniqueness of initiating users and receiving users
    sets = events.group_by { |event| [event.initiating_user_id, event.receiving_user_id] }.keys
    initiating_user_count = sets.map(&:first).uniq.count
    receiving_user_count  = sets.map(&:last).uniq.count

    "#{initiating_user_count} #{people_text_presenter(initiating_user_count)} " +
      description + " #{receiving_user_count} other #{people_text_presenter(receiving_user_count)}\n"
  end

  def self.people_text_presenter(people_count)
    people_count > 1 ? 'people' : 'person'
  end

end
