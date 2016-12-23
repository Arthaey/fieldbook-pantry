class ItemFormatter
  TOTAL_WIDTH = 60
  FORMATTING_WIDTH = 3 # bullet point & spaces

  def initialize(type = :no_date)
    case type
    when :canned
      @date_method = :use_by_date
      @date_formats = ['%b%y']
      @final_format = '[%5s]'
    when :expiring
      @date_method = :use_by_date
      @date_formats = ['%a', '%-m/%-d']
      @final_format = '[%s %5s]'
    when :frozen
      @date_method = :purchased_date
      @date_formats = ['%-m/%-d']
      @final_format = '[%5s]'
    end
  end

  def format(item)
    date = @date_method ? item.send(@date_method) : nil
    date_str = format_date(date)
    width = TOTAL_WIDTH - FORMATTING_WIDTH - date_str.length
    sprintf("- %-#{width}s %s\n", item.name, date_str)
  end

  private

  def format_date(date)
    return '' unless date
    date_components = @date_formats.map { |format| date.strftime(format) }
    sprintf(@final_format, *date_components)
  end
end
