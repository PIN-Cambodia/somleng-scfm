require "webmock/rspec"

# From: https://gist.github.com/2596158
# Thankyou Bartosz Blimke!
# https://twitter.com/bartoszblimke/status/198391214247124993

module WebMockLastRequest
  def clear_requests!
    @requests = nil
  end

  def requests
    @requests ||= []
  end

  def last_request=(request_signature)
    requests << request_signature
  end
end

WebMock.extend(WebMockLastRequest)
if ENV['SELENIUM_REMOTE_HOST'].present?
  WebMock.allow_net_connect!
else
  WebMock.disable_net_connect!(allow_localhost: true)
end

WebMock.after_request do |request_signature, _response|
  WebMock.last_request = request_signature
end
