require 'pantry_item'

RSpec.describe PantryItem do
  before(:all) do
    Timecop.travel(Date.parse('2016-12-29'))
  end

  after(:all) do
    Timecop.return
  end

  context '#use_by_date' do
    it 'returns nil if it does not have a use-by date' do
      item = described_class.new
      expect(item.use_by_date).to be_nil
    end

    it 'returns its use-by date' do
      item = described_class.new(use_by: '2016-12-31')
      expect(item.use_by_date).to eq(Date.parse('2016-12-31'))
    end
  end

  context '#expires_within?' do
    it 'returns false if it does not have a use-by date' do
      item = described_class.new
      expect(item.expires_within?(3)).to eq(false)
    end

    it 'returns true if it expires within the timeframe' do
      item = described_class.new(use_by: '2016-12-31')
      expect(item.expires_within?(3)).to eq(true)
    end

    it 'returns true if it has already expired' do
      item = described_class.new(use_by: '2016-12-28')
      expect(item.expires_within?(3)).to eq(true)
    end
  end

  context '#frozen?' do
    it 'returns true if it is frozen' do
      item = described_class.new(notes: 'frozen')
      expect(item.frozen?).to eq(true)
    end

    it 'returns false if it is not frozen' do
      item = described_class.new(notes: 'not frozen')
      expect(item.frozen?).to eq(false)
    end
  end
end
