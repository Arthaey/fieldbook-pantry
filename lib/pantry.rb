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
    @unknown ||= @items.select do |item|
      item.use_by_date.nil? && !item.frozen?
    end
  end

  private

  def request_data!
    uri = request_uri
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    request.basic_auth(ENV['FIELDBOOK_KEY'], ENV['FIELDBOOK_SECRET'])
    http.use_ssl = true

    response = http.request(request)
    JSON.parse(response.body)
  end

  def request_uri
    book_id    = ENV['FIELDBOOK_BOOK_ID']
    sheet_name = ENV['FIELDBOOK_SHEET_NAME']
    URI.parse("https://api.fieldbook.com/v1/#{book_id}/#{sheet_name}")
  end
end
