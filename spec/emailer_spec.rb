require 'emailer'

RSpec.describe Emailer do
  before(:all) do
    Timecop.travel(Date.parse('2016-12-29'))
  end

  after(:all) do
    Timecop.return
  end

  it 'generates a report of expiring items' do
    emailer = described_class.new
    expected_report = File.read('spec/data/report.txt')
    expect(emailer.report).to eq(expected_report)
  end
end
