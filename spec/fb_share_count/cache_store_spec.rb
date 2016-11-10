require 'spec_helper'
require 'fb_share_count/cache_store'

describe FbShareCount::CacheStore do
  describe '.get' do
    it 'gets a value' do
      stub_share_count_cache
      key = 'testkey'
      value = 'testvalue'
      expect(@redis)
        .to(receive(:get))
        .with(key)
        .and_return value
      return_value = FbShareCount::CacheStore.get key
      expect(return_value).to eq value
    end
  end

  describe '.set' do
    it 'sets a key value pair with an expire time' do
      stub_share_count_cache
      stub_share_count_expire_time
      key = 'testkey'
      value = 'testvalue'
      expect(@redis)
        .to(receive(:set))
        .with key, value
      expect(@redis)
        .to(receive(:expire))
        .with key, @expire_time
      FbShareCount::CacheStore.set key, value
    end
  end

  def stub_share_count_cache
    @redis = Redis.new
    allow(FbShareCount)
      .to(receive(:cache_store))
      .and_return @redis
  end

  def stub_share_count_expire_time
    @expire_time = 60
    expect(FbShareCount)
      .to(receive(:cache_expire_time))
      .and_return @expire_time
  end
end
