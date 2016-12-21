require 'date'

require 'pantry'

RSpec.describe Pantry do
  let(:pantry) { Pantry.new }

  before(:all) do
    Timecop.travel(Date.parse('2016-12-29'))

    ENV['FIELDBOOK_KEY'] = 'test-user'
    ENV['FIELDBOOK_SECRET'] = 'test-password'
    ENV['FIELDBOOK_BOOK_ID'] = 'test-book-id'
    ENV['FIELDBOOK_SHEET_NAME'] = 'test-sheet-name'
  end

  after(:all) do
    Timecop.return
  end

	it 'should get all pantry items' do
    expect(pantry.items.count).to eq(14)
  end

  it 'should find only those expiring this week' do
    expect(pantry.expiring.count).to eq(2)
  end
  
  it 'should find frozen items' do
    expect(pantry.frozen.count).to eq(6)
  end

  it 'should find items with unknown expiration' do
    expect(pantry.unknown_expiration.count).to eq(1)
  end

end
