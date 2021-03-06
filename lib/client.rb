require 'uri'
require 'json'
require 'base64'
require 'openssl'
require 'net/http'

class HTTPClient 
  def initialize(params)
    @appkey = params[:appkey]
    @secret = params[:secret]
  end
  def request(path, body)
    headers = self.sign(path)
    http = Net::HTTP.new("dxw.san" + "kuai.com")
    http.request_put(path, body.to_json, headers)
  end
  def sign(path)
    timestamp = Time.now.gmtime.strftime('%a, %d %b %Y %H:%M:%S GMT')
    req = "PUT #{path}\n#{timestamp}"
    hash = OpenSSL::HMAC.digest('sha1', @secret, req)
    auth = Base64.encode64 hash
    {
      "Date": timestamp,
      "Authorization": "MWS #{@appkey}:#{auth}",
      "Content-Type": "application/json"
    }
  end
end