require 'date'
require 'pantry'

class Emailer
  TOTAL_WIDTH = 60
  FORMATTING_WIDTH = 3 # bullet point & spaces

  def report
    pantry = Pantry.new

    text = format_title
    text << format_items('EXPIRING THIS WEEK', pantry.expiring, :use_by_date)
    text << format_items('FROZEN FOOD', pantry.frozen, :purchased_date)
    text << format_items('UNKNOWN EXPIRATION', pantry.unknown_expiration)
  end

  private

  def format_title
    today = Date.today.strftime('%A, %-m/%-d')
    text = "REPORT FOR #{today.upcase}\n"
    text << '=' * TOTAL_WIDTH + "\n\n"
  end

  def format_items(heading, items, date_method = nil)
    text = "#{heading}:\n"

    items.each do |item|
      date_str = format_date(item, date_method)
      width = TOTAL_WIDTH - FORMATTING_WIDTH - date_str.length
      text << format("- %-#{width}s %s\n", item.name, date_str)
    end

    text << "\n"
  end

  def format_date(item, date_method)
    date = date_method ? item.send(date_method) : nil
    return '' unless date

    month_day = date.strftime('%-m/%-d')

    case date_method
    when :use_by_date
      weekday = date.strftime('%a')
      format('[%s %5s]', weekday, month_day)
    when :purchased_date
      format('[%5s]', month_day)
    end
  end
end
