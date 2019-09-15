require 'test_helper'

class EventTest < ActiveSupport::TestCase

  test "one simple test example" do

    Event.create kind: 'opening', starts_at: DateTime.parse("2014-08-04 09:30"), ends_at: DateTime.parse("2014-08-04 12:30"), weekly_recurring: true
    Event.create kind: 'appointment', starts_at: DateTime.parse("2014-08-11 10:30"), ends_at: DateTime.parse("2014-08-11 11:30")

    availabilities = Event.availabilities DateTime.parse("2014-08-10")

    assert_equal '2014/08/10', availabilities[0][:date]
    assert_equal [], availabilities[0][:slots]

    assert_equal '2014/08/11', availabilities[1][:date]
    assert_equal ["9:30", "10:00", "11:30", "12:00"], availabilities[1][:slots]

    assert_equal '2014/08/12', availabilities[2][:date]
    assert_equal [], availabilities[2][:slots]

    assert_equal '2014/08/13', availabilities[3][:date]
    assert_equal [], availabilities[3][:slots]

    assert_equal '2014/08/14', availabilities[4][:date]
    assert_equal [], availabilities[4][:slots]

    assert_equal '2014/08/15', availabilities[5][:date]
    assert_equal [], availabilities[5][:slots]

    assert_equal '2014/08/16', availabilities[6][:date]
    assert_equal [], availabilities[6][:slots]

    assert_equal 7, availabilities.length
  end

  test "recurring week openings for 4 weeks" do
    Event.create kind: 'opening', starts_at: DateTime.parse("2015-08-04 09:30"), ends_at: DateTime.parse("2015-08-04 12:30"), weekly_recurring: true
    Event.create kind: 'appointment', starts_at: DateTime.parse("2015-09-01 10:30"), ends_at: DateTime.parse("2015-09-01 11:30")

    availabilities = Event.availabilities DateTime.parse("2015-08-29")

    assert_equal '2015/08/29', availabilities[0][:date]
    assert_equal [], availabilities[0][:slots]

    assert_equal '2015/08/30', availabilities[1][:date]
    assert_equal [], availabilities[1][:slots]

    assert_equal '2015/08/31', availabilities[2][:date]
    assert_equal [], availabilities[2][:slots]

    assert_equal '2015/09/01', availabilities[3][:date]
    assert_equal ["9:30", "10:00", "11:30", "12:00"], availabilities[3][:slots]

    assert_equal '2015/09/02', availabilities[4][:date]
    assert_equal [], availabilities[4][:slots]

    assert_equal '2015/09/03', availabilities[5][:date]
    assert_equal [], availabilities[5][:slots]

    assert_equal '2015/09/04', availabilities[6][:date]
    assert_equal [], availabilities[6][:slots]

    assert_equal 7, availabilities.length
  end

  test "with multiple openings (morning and post Lunch) on same day" do

    Event.create kind: 'opening', starts_at: DateTime.parse("2019-08-23 09:30"), ends_at: DateTime.parse("2019-08-23 13:00"), weekly_recurring: true
    Event.create kind: 'opening', starts_at: DateTime.parse("2019-08-23 14:00"), ends_at: DateTime.parse("2019-08-23 17:00"), weekly_recurring: true

    Event.create kind: 'appointment', starts_at: DateTime.parse("2019-08-30 10:30"), ends_at: DateTime.parse("2019-08-30 11:30")
    Event.create kind: 'appointment', starts_at: DateTime.parse("2019-08-30 14:30"), ends_at: DateTime.parse("2019-08-30 15:30")

    availabilities = Event.availabilities DateTime.parse("2019-08-25")

    assert_equal '2019/08/25', availabilities[0][:date]
    assert_equal [], availabilities[0][:slots]

    assert_equal '2019/08/26', availabilities[1][:date]
    assert_equal [], availabilities[1][:slots]

    assert_equal '2019/08/27', availabilities[2][:date]
    assert_equal [], availabilities[2][:slots]

    assert_equal '2019/08/28', availabilities[3][:date]
    assert_equal [], availabilities[3][:slots]

    assert_equal '2019/08/29', availabilities[4][:date]
    assert_equal [], availabilities[4][:slots]

    assert_equal '2019/08/30', availabilities[5][:date]
    assert_equal ["9:30", "10:00", "11:30", "12:00", "12:30", "14:00", "15:30", "16:00", "16:30"],
                  availabilities[5][:slots]

    assert_equal '2019/08/31', availabilities[6][:date]
    assert_equal [], availabilities[6][:slots]

    assert_equal 7, availabilities.length
  end

  test "recurring week openings and appointments with year change" do

    Event.create kind: 'opening', starts_at: DateTime.parse("2018-12-21 09:30"), ends_at: DateTime.parse("2018-12-21 12:30"), weekly_recurring: true
    Event.create kind: 'appointment', starts_at: DateTime.parse("2019-01-04 10:30"), ends_at: DateTime.parse("2019-01-04 11:30")

    availabilities = Event.availabilities DateTime.parse("2019-01-01")

    assert_equal '2019/01/01', availabilities[0][:date]
    assert_equal [], availabilities[0][:slots]

    assert_equal '2019/01/02', availabilities[1][:date]
    assert_equal [], availabilities[1][:slots]

    assert_equal '2019/01/03', availabilities[2][:date]
    assert_equal [], availabilities[2][:slots]

    assert_equal '2019/01/04', availabilities[3][:date]
    assert_equal ["9:30", "10:00", "11:30", "12:00"], availabilities[3][:slots]

    assert_equal '2019/01/05', availabilities[4][:date]
    assert_equal [], availabilities[4][:slots]

    assert_equal '2019/01/06', availabilities[5][:date]
    assert_equal [], availabilities[5][:slots]

    assert_equal '2019/01/07', availabilities[6][:date]
    assert_equal [], availabilities[6][:slots]

    assert_equal 7, availabilities.length
  end

  test "new openings added on different days in upcoming seven days" do

    Event.create kind: 'opening', starts_at: DateTime.parse("2019-09-17 09:30"), ends_at: DateTime.parse("2019-09-17 11:00"), weekly_recurring: true
    Event.create kind: 'opening', starts_at: DateTime.parse("2019-09-18 09:30"), ends_at: DateTime.parse("2019-09-18 11:00"), weekly_recurring: true

    Event.create kind: 'appointment', starts_at: DateTime.parse("2019-09-17 09:30"), ends_at: DateTime.parse("2019-09-17 10:00")
    Event.create kind: 'appointment', starts_at: DateTime.parse("2019-09-17 10:30"), ends_at: DateTime.parse("2019-09-17 11:00")

    Event.create kind: 'appointment', starts_at: DateTime.parse("2019-09-18 09:30"), ends_at: DateTime.parse("2019-09-18 10:00")
    Event.create kind: 'appointment', starts_at: DateTime.parse("2019-09-18 10:30"), ends_at: DateTime.parse("2019-09-18 11:00")

    availabilities = Event.availabilities DateTime.parse("2019-09-15")

    assert_equal '2019/09/15', availabilities[0][:date]
    assert_equal [], availabilities[0][:slots]

    assert_equal '2019/09/16', availabilities[1][:date]
    assert_equal [], availabilities[1][:slots]

    assert_equal '2019/09/17', availabilities[2][:date]
    assert_equal ["10:00"], availabilities[2][:slots]

    assert_equal '2019/09/18', availabilities[3][:date]
    assert_equal ["10:00"], availabilities[3][:slots]

    assert_equal '2019/09/19', availabilities[4][:date]
    assert_equal [], availabilities[4][:slots]

    assert_equal '2019/09/20', availabilities[5][:date]
    assert_equal [], availabilities[5][:slots]

    assert_equal '2019/09/21', availabilities[6][:date]
    assert_equal [], availabilities[6][:slots]

    assert_equal 7, availabilities.length
  end
end