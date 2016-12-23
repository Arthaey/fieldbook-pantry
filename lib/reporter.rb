require 'date'

require_relative 'item_formatter'
require_relative 'pantry'

class Reporter
  CANNED   = ItemFormatter.new(:canned)
  EXPIRING = ItemFormatter.new(:expiring)
  FROZEN   = ItemFormatter.new(:frozen)
  UNKNOWN  = ItemFormatter.new

  def initialize
    @pantry = Pantry.new
  end

  def report
    text = format_title
    text << format('EXPIRING THIS WEEK', @pantry.expiring, EXPIRING)
    text << format('CANNED FOOD', @pantry.canned, CANNED)
    text << format('FROZEN FOOD', @pantry.frozen, FROZEN)
    text << format('UNKNOWN EXPIRATION', @pantry.unknown_expiration, UNKNOWN)
  end

  private

  def format_title
    today = Date.today.strftime('%A, %-m/%-d')
    text = "REPORT FOR #{today.upcase}\n"
    text << '=' * ItemFormatter::TOTAL_WIDTH + "\n\n"
  end

  def format(heading, items, formatter)
    text = "#{heading}:\n"
    items.each do |item|
      text << formatter.format(item)
    end
    text << "\n"
  end
end
