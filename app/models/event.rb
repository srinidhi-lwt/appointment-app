class Event < ApplicationRecord

  before_save :set_day_of_week

  scope :by_kind, -> (type) { where(kind: type) }
  scope :recurring, -> { where(weekly_recurring: true) }

  def set_day_of_week
  end
end
