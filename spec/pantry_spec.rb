require 'date'

require 'pantry'

RSpec.describe Pantry do
  let(:pantry) { described_class.new }

  before(:all) do
    Timecop.travel(Date.parse('2016-12-29'))
  end

  after(:all) do
    Timecop.return
  end

  it 'gets all pantry items' do
    expect(pantry.items.count).to eq(13)
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

  context '#canned' do
    it 'finds only canned items' do
      expect(pantry.canned.count).to eq(3)
    end

    it 'sorts them by use-by date, then alphabetically' do
      expected_names = [
        'Tuna',
        'Bolognese sauce',
        'Salmon',
      ]
      expect(pantry.canned.map(&:name)).to eq(expected_names)
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

  it 'uses configuration from given DOTENV file' do
    original_dotenv = ENV['DOTENV']
    ENV['DOTENV'] = 'spec/data/override.env'

    other_pantry = described_class.new
    expect(other_pantry.items.count).to eq(1)

    ENV['DOTENV'] = original_dotenv
  end
end
