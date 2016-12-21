require 'pantry_item'

RSpec.describe PantryItem do

  before(:all) do
    Timecop.travel(Date.parse('2016-12-29'))
  end

  after(:all) do
    Timecop.return
  end

  context '#use_by_date' do
    it 'should return nil if it does not have a use-by date' do
      item = PantryItem.new
      expect(item.use_by_date).to be_nil
    end

    it 'should return its use-by date' do
      item = PantryItem.new(use_by: '2016-12-31')
      expect(item.use_by_date).to eq(Date.parse('2016-12-31'))
    end
  end

  context '#expires_within?' do
    it 'should return false if it does not have a use-by date' do
      item = PantryItem.new
      expect(item.expires_within?(3)).to eq(false)
    end

    it 'should return true if it expires within the timeframe' do
      item = PantryItem.new(use_by: '2016-12-31')
      expect(item.expires_within?(3)).to eq(true)
    end

    it 'should return true if it has already expired' do
      item = PantryItem.new(use_by: '2016-12-28')
      expect(item.expires_within?(3)).to eq(true)
    end
  end

  context '#frozen?' do
    it 'should return true if it is frozen' do
      item = PantryItem.new(notes: 'frozen')
      expect(item.frozen?).to eq(true)
    end

    it 'should return false if it is not frozen' do
      item = PantryItem.new(notes: 'not frozen')
      expect(item.frozen?).to eq(false)
    end
  end

end
