class Event < ApplicationRecord

  before_save :set_day_of_week

  scope :by_kind, -> (type) { where(kind: type) }
  scope :recurring, -> { where(weekly_recurring: true) }
  scope :by_date, -> (dates) { where('date(starts_at) IN (?)', dates) }

  def set_day_of_week
    self.day_of_week = day_name_for(starts_at.to_date)
  end

  def self.availabilities(given_date)
    given_date, upto_seven_days = seven_days_from(given_date)
    next_seven_days = seven_days_range(given_date)

    appointments = by_kind('appointment')
                     .where(starts_at: next_seven_days)
                     .group_by(&:day_of_week)

    latest_opening_dates = by_kind('opening').recurring
                            .select('MAX(date(starts_at)) AS event_date')
                            .group('day_of_week')
                            .map(&:event_date)

    openings = by_date(latest_opening_dates)
                .group_by(&:day_of_week)
  end

  private

  def day_name_for(date)
    self.class.day_name_for(date)
  end
end
