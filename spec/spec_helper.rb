$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'fb_share_count'
require 'logger'

FbShareCount.configure do |config|
  config.logger = Logger.new File::NULL
end
