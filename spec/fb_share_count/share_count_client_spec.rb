require 'spec_helper'
require 'webmock/rspec'
require 'fb_share_count/share_count_client'

describe FbShareCount::ShareCountClient do
  describe '.call' do
    it 'fetches URL share info' do
      url = 'testurl'
      body = share_body url, 100, 100
      stub_graph_request 200, body.to_json
      share_info = FbShareCount::ShareCountClient.call [url]
      expect(share_info[url]).to eq body[url][:share]
    end

    it 'returns 0 counts on error' do
      url = 'testurl'
      body = share_body url, 0, 0
      stub_graph_request 500, '{}'
      share_info = FbShareCount::ShareCountClient.call [url]
      expect(share_info[url]).to eq body[url][:share]
    end

    it 'splits requests when too many URLs are requested' do
      request_url = 'http://graph.facebook.com/?ids='
      request1_urls = (1..50).map { |i| "url#{i}" }
      request2_urls = ['url51']
      stub_graph_request 200, '{}', "#{request_url}#{request1_urls.join(',')}"
      body = share_body 'url51', 100, 100
      stub_graph_request 200, body.to_json, "#{request_url}#{request2_urls.join(',')}"
      share_info = FbShareCount::ShareCountClient.call request1_urls + request2_urls
      expect(share_info['url51']).to eq body['url51'][:share]
    end
  end

  def stub_graph_request(status, body, url = nil)
    url ||= %r{http://graph.facebook.com/\?ids=}
    stub_request(:get, url).to_return status: status,
                                      body: body
  end

  def share_body(url, comment_count, share_count)
    {
      url => {
        share: {
          comment_count: comment_count,
          share_count: share_count
        }
      }
    }
  end
end
