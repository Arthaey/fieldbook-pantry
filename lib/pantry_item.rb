class PantryItem
  def initialize(json = {})
    @data = OpenStruct.new(json)

    # OpenStruct.new doesn't do nested structures, so clean up after.
    items = @data.items || []
    @data.items = items.map { |item| OpenStruct.new(item) }
  end

  def name
    @data.items.map { |item| item[:name] }.join('; ')
  end

  def purchased_date
    @purchased_date ||= parse_date(@data.purchased)
  end

  def use_by_date
    @use_by_date ||= parse_date(@data.use_by)
  end

  def canned?
    @data.notes == 'canned'
  end

  def frozen?
    @data.notes == 'frozen'
  end

  def expires_within?(days)
    days_until_expired.nil? ? false : days_until_expired <= days
  end

  private

  def parse_date(value)
    value.nil? ? nil : Date.parse(value)
  end

  def days_until_expired
    return nil if use_by_date.nil?
    (use_by_date - Date.today).to_i
  end
end
