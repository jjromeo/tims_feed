RSpec.describe TimsFeed do
  describe '#information_points' do
    it 'returns the correct data structure' do
      VCR.use_cassette('tims') do
        fetcher = TimsFeed.new
        expect(fetcher.information_points.first).to include({ commentary: an_instance_of(String), display_points: array_including(an_instance_of(Hash))})
      end
    end
  end
end
