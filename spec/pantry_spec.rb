require 'date'

require 'pantry'

RSpec.describe Pantry do
  let(:pantry) { described_class.new } # pantry.json via FakeWeb

  before(:all) do
    Timecop.travel(Date.parse('2016-12-29'))
  end

  after(:all) do
    Timecop.return
  end

  it 'gets all pantry items' do
    expect(pantry.items.count).to eq(11)
  end

  context '#expiring' do
    it 'finds only those expiring this week' do
      expect(pantry.expiring.count).to eq(2)
    end

    it 'sorts them by soonest to expire' do
      expected_names = ['Half & Half', 'Milk']
      expect(pantry.expiring.map(&:name)).to eq(expected_names)
    end
  end

  context '#frozen' do
    it 'finds only frozen items' do
      expect(pantry.frozen.count).to eq(3)
    end

    it 'sorts them by purchase date, then alphabetically' do
      expected_names = [
        'Sausage (chicken apple)',
        'Ravioli (beef)',
        'Soup dumplings',
      ]
      expect(pantry.frozen.map(&:name)).to eq(expected_names)
    end
  end

  it 'finds items with unknown expiration' do
    expect(pantry.unknown_expiration.count).to eq(1)
  end
end
