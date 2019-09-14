module DateConcern
  extend ActiveSupport::Concern

  included do
    def self.day_name_for(date = Date.today)
      date.strftime("%A").downcase
    end

    def self.seven_days_from(date)
      [date, date + 1.week]
    end

    def self.seven_days_range(date)
      date.beginning_of_day...(date + 1.week).end_of_day
    end
  end
end