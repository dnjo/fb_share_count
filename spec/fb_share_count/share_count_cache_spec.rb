require 'spec_helper'
require 'fb_share_count/share_count_cache'

describe FbShareCount::ShareCountCache do
  describe '.get' do
    it 'gets info from cache' do
      url = 'testurl'
      info = { testinfo: 'testvalue' }
      expect(FbShareCount::CacheStore)
        .to(receive(:get))
        .with("share-count-#{url}")
        .and_return info.to_json
      return_info = FbShareCount::ShareCountCache.get [url]
      expect(return_info[url]).to eq info
    end

    it 'fetches and stores in cache if not in cache' do
      url = 'testurl'
      info = { testinfo: 'testvalue' }
      expect(FbShareCount::CacheStore)
        .to(receive(:get))
        .with("share-count-#{url}")
        .and_return nil
      expect(FbShareCount::ShareCountClient)
        .to(receive(:call))
        .with([url])
        .and_return url => info
      expect(FbShareCount::CacheStore)
        .to(receive(:set))
        .with "share-count-#{url}", info.to_json
      return_info = FbShareCount::ShareCountCache.get [url]
      expect(return_info[url]).to eq info
    end
  end
end
