require 'dotenv'

require 'net/http'
require 'uri'
require 'json'

require_relative 'pantry_item'

class Pantry
  WATCH_PERIOD = 7 # days

  attr_reader :items

  def initialize
    @config = load_config
    @items = request_data!.map { |json| PantryItem.new(json) }
  end

  def expiring
    expiring = @items.select { |item| item.expires_within?(WATCH_PERIOD) }
    expiring.sort_by(&:use_by_date)
  end

  def canned
    sort(@items.select(&:canned?), :use_by_date)
  end

  def frozen
    sort(@items.select(&:frozen?), :purchased_date)
  end

  def unknown_expiration
    unknowns = @items.select do |item|
      item.use_by_date.nil? && !item.frozen? && !item.canned?
    end
    sort(unknowns, :purchased_date)
  end

  private

  def sort(items, date_method)
    far_future = Date.parse('9999-12-31')
    items.sort_by { |item| [item.send(date_method) || far_future, item.name] }
  end

  def request_data!
    uri = request_uri
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    request.basic_auth(config('FIELDBOOK_KEY'), config('FIELDBOOK_SECRET'))
    http.use_ssl = true

    response = http.request(request)
    JSON.parse(response.body)
  end

  def request_uri
    book_id    = config('FIELDBOOK_BOOK_ID')
    sheet_name = config('FIELDBOOK_SHEET_NAME')
    URI.parse("https://api.fieldbook.com/v1/#{book_id}/#{sheet_name}")
  end

  def config(key)
    @config[key] || ENV[key]
  end

  def load_config
    filename = ENV['DOTENV'] || '.env'
    filename.empty? ? {} : Dotenv.load(filename)
  end
end
