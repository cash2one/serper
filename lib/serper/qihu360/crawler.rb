class Serper::Qihu360
  def serp_url(keyword,page)
    keyword = keyword.gsub(" ","+")
    page = page.to_i > 1 ? "&pn=#{page.to_i}" : ''
    URI.escape("http://www.haosou.com/s?q=#{keyword}#{page}&ie=utf-8&src=360sou_newhome")
  end

  def search(keyword,page)
    Serper::Crawler.get_serp(
        serp_url(keyword,page),
        {
            'Referer' => 'http://www.haosou.com/',
            'User-Agent' => Serper::Crawler.rand_ua
        }).body
  end
end
