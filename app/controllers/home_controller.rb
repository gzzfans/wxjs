class HomeController < ApplicationController
  require 'digest/sha1'
  def index
    @access_token = AccessToken.get_access_token
    @jsapi_ticket = JsapiTicket.get_jsapi_ticket(@access_token)
    @noncestr = Digest::SHA256.hexdigest("dface123456")[0,32]
    @timestamp = Time.now.to_i
    @url = "http://wxjs.dface.cn"
    url_key = "jsapi_ticket=#{@jsapi_ticket}&noncestr=#{@noncestr}&timestamp=#{@timestamp}&url=#{@url}"
    @signature = Digest::SHA1.hexdigest(url_key)
  end

  def error_signature
    @access_token = AccessToken.get_remote
    @jsapi_ticket = JsapiTicket.get_from_remote(@access_token)
    @noncestr = Digest::SHA256.hexdigest("dface123456")[0,32]
    @timestamp = Time.now.to_i
    @url = "http://wxjs.dface.cn"
    url_key = "jsapi_ticket=#{@jsapi_ticket}&noncestr=#{@noncestr}&timestamp=#{@timestamp}&url=#{@url}"
    @signature = Digest::SHA1.hexdigest(url_key)
  end
end
