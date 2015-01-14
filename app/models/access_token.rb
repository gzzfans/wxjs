class AccessToken

  def self.url
    # 由于测试，先把url写死
    "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=wx3f44f37038103ff2&secret=999b43178f1d1d12b29ea1060b6ff844"
  end

  def self.get_access_token
    access_token = $redis.get("wxjs:access_token")
    if access_token.blank?
      access_token = self.get_remote(self.url)
    end
  end

  def self.get_remote(url = self.url)
    access_token = JSON.parse(RestClient.get url)
    return nil if access_token["errcode"].present?
    $redis.set("wxjs:access_token", access_token["access_token"])
    $redis.expire("wxjs:access_token", 7190)
    access_token["access_token"]
  end
end
