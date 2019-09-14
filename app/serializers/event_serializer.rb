class EventSerializer < BaseSerializer
  def call
    {
      date: key.to_date.strftime('%Y/%m/%d'),
      slots: value
    }
  end
end