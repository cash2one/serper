class Serper::Baidu
  def serp_url(keyword,page)
    keyword = keyword.gsub(" ","+")
    page = page.to_i > 1 ? "&pn=#{page.to_i-1}0" : ''
    URI.escape("http://www.baidu.com/s?wd=#{keyword}#{page}&ie=utf-8&inputT=#{1000+rand(1000)}")
  end

  def search(keyword,page)
    Serper::Crawler.get_serp(
        serp_url(keyword,page),
        {
            'Referer' => 'http://www.baidu.com/',
            'User-Agent' => Serper::Crawler.rand_ua
        }).body
  end
end
