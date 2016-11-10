require 'spec_helper'

describe FbShareCount do
  it 'has a version number' do
    expect(FbShareCount::VERSION).not_to be nil
  end

  describe '.get_for_urls' do
    it 'fetches share count from cache' do
      urls = %w(url1 url2)
      share_count = 'share_count'
      expect(FbShareCount::ShareCountCache)
        .to(receive(:get))
        .with(urls)
        .and_return share_count
      returned_share_count = FbShareCount.get_for_urls urls
      expect(returned_share_count).to eq share_count
    end
  end
end
