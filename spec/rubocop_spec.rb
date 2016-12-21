RSpec.describe 'Rubocop Analysis' do
  let(:report) { `rubocop` }

  it 'has no offenses' do
    expect(report).to match(/no\ offenses\ detected/)
  end
end
