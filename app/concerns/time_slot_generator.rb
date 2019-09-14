module TimeSlotGenerator
  extend ActiveSupport::Concern

  included do
    def self.time_slots_for(events)
      return [] if events.blank?

      [].tap do |slots|
        events.each do |event|
          (event.starts_at.to_i...event.ends_at.to_i).step(30.minutes) do |slot|
            slots << time_format(slot)
          end
        end
      end.flatten
    end

    def self.time_format(slot)
      Time.at(slot).utc.strftime("%-H:%M")
    end
  end
end
