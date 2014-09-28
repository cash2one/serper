module Serper
  class BaiduMobile

    def serp_url(keyword,page)
      keyword = keyword.gsub(" ","+")
      page = page.to_i > 1 ? "&pn=#{page.to_i-1}0" : ''
      URI.escape("http://m.baidu.com/from=844b/pu=sz@1321_1001/s?word=#{keyword}#{page}&sa=ib&ts=0&ms=1")
    end

    def search(keyword,page)
      n = 5
      begin
        result = Crawler.get_serp(
            serp_url(keyword,page),
            {
                'Referer' => 'http://m.baidu.com/',
                'User-Agent' => 'Mozilla/5.0 (iPhone; CPU iPhone OS 5_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A334 Safari/7534.48.3'
            })
        raise if result.request.last_uri.to_s.include?('verify.baidu.com')
      rescue StandardError,TimeoutError
        pp 'ERROR!',$!
        sleep(rand(3))
        n = n - 1
        retry if n > 0
      end
      result
    end

  end
end