module DateConcern
  extend ActiveSupport::Concern

  included do
    def self.day_name_for(date = Date.today)
      date.strftime("%A").downcase
    end
  end
end