class Event < ApplicationRecord

  before_save :set_day_of_week

  scope :by_kind, -> (type) { where(kind: type) }
  scope :recurring, -> { where(weekly_recurring: true) }

  def set_day_of_week
    self.day_of_week = day_name_for(starts_at.to_date)
  end

  private

  def day_name_for(date)
    self.class.day_name_for(date)
  end
end
