require 'dotenv'

require 'net/http'
require 'uri'
require 'json'

Dotenv.load

class Pantry

  WATCH_PERIOD = 7 # days

  attr_reader :items

  def initialize
    data = request_data!
    @items = data.map { |json| PantryItem.new(json) }
  end

  def expiring
    @expiring ||= @items.select { |item| item.expires_within?(WATCH_PERIOD) }
  end

  def frozen
    @frozen ||= @items.select(&:frozen?)
  end

  def unknown_expiration
    @unknown ||= @items.select { |item| item.use_by_date.nil? and !item.frozen? }
  end

  private

  def request_data!
    book_id    = ENV['FIELDBOOK_BOOK_ID']
    sheet_name = ENV['FIELDBOOK_SHEET_NAME']
    key        = ENV['FIELDBOOK_KEY']
    secret     = ENV['FIELDBOOK_SECRET']

    uri = URI.parse("https://api.fieldbook.com/v1/#{book_id}/#{sheet_name}")

    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    request.basic_auth(key, secret)
    http.use_ssl = true

    response = http.request(request)
    JSON.parse(response.body)
  end

end
