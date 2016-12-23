require 'dotenv'

require 'net/http'
require 'uri'
require 'json'

require_relative 'pantry_item'

class Pantry
  WATCH_PERIOD = 7 # days

  attr_reader :items

  def initialize
    @config = Dotenv.load(ENV['DOTENV'] || '.env')

    data = request_data!
    @items = data.map { |json| PantryItem.new(json) }
  end

  def expiring
    expiring = @items.select { |item| item.expires_within?(WATCH_PERIOD) }
    expiring.sort_by(&:use_by_date)
  end

  def canned
    canned = @items.select(&:canned?)
    canned.sort_by { |item| [item.use_by_date, item.name] }
  end

  def frozen
    frozen = @items.select(&:frozen?)
    frozen.sort_by { |item| [item.purchased_date, item.name] }
  end

  def unknown_expiration
    @items.select do |item|
      item.use_by_date.nil? && !item.frozen?
    end
  end

  private

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
end
