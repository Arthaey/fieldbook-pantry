require 'item_formatter'
require 'pantry_item'

RSpec.describe ItemFormatter do
  let(:item_data) do
    {
      use_by: '2016-12-29',
      purchased: '2016-12-05',
      items: [{ 'name' => 'Peas' }]
    }
  end

  before(:all) do
    Timecop.travel(Date.parse('2016-12-29'))
  end

  after(:all) do
    Timecop.return
  end

  it 'formats expiring items' do
    item = PantryItem.new(item_data)
    expected = "- Peas                                           [Thu 12/29]\n"
    formatter = described_class.new(:expiring)
    expect(formatter.format(item)).to eq(expected)
  end

  it 'formats canned items' do
    item = PantryItem.new(item_data.merge(notes: 'canned'))
    expected = "- Peas                                               [Dec16]\n"
    formatter = described_class.new(:canned)
    expect(formatter.format(item)).to eq(expected)
  end

  it 'formats frozen items' do
    item = PantryItem.new(item_data.merge(notes: 'frozen'))
    expected = "- Peas                                               [ 12/5]\n"
    formatter = described_class.new(:frozen)
    expect(formatter.format(item)).to eq(expected)
  end

  it 'formats unknown expiration items' do
    item = PantryItem.new(item_data)
    expected = "- Peas                                               [ 12/5]\n"
    formatter = described_class.new(:unknown_expiration)
    expect(formatter.format(item)).to eq(expected)
  end
end
