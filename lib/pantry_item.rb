class PantryItem
  def initialize(json = {})
    @data = OpenStruct.new(json)
  end

  def use_by_date
    @use_by_date ||= (@data.use_by.nil? ? nil : Date.parse(@data.use_by))
  end

  def frozen?
    @data.notes == 'frozen'
  end

  def expires_within?(days)
    days_until_expired.nil? ? false : days_until_expired <= days
  end

  private

  def days_until_expired
    return nil if use_by_date.nil?
    (use_by_date - Date.today).to_i
  end
end
