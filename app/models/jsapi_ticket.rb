class JsapiTicket

  def self.get_jsapi_ticket(access_token)
    jsapi_ticket = $redis.get("wxjs:jsapi_ticket")
    if jsapi_ticket.blank?
      jsapi_ticket = self.get_from_remote(access_token)
    end
  end

  def self.get_from_remote(access_token)
    return nil if access_token.blank?
    jsapi_ticket = JSON.parse(RestClient.get("https://api.weixin.qq.com/cgi-bin/ticket/getticket?access_token=#{access_token}&type=jsapi"))
    return nil if jsapi_ticket["errcode"] != 0
    $redis.set("wxjs:jsapi_ticket", jsapi_ticket["ticket"])
    $redis.expire("wxjs:jsapi_ticket", 7190)
    jsapi_ticket["ticket"]
  end

end
