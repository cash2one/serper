class Serper::BaiduMobile

  #百度转码跟踪原页面
  def url_follow(url)
    return nil if url.nil?
    begin
      url = URI.escape(url['href'])
      trans = HTTParty.get(url)
      url = trans.request.last_uri.to_s
      if /^http:\/\/m\.baidu\.com\// === url
        url = URI.escape(trans.css('a#tc_ori')[0].href)
        url = HTTParty.get(url).request.last_uri.to_s
      end
    rescue
      pp url
      pp $!
      url = URI.escape($!.to_s[/http:\/\/.+/]) || url
    end
    url
  end

  def _parse_ads_top(file)
    result = []
    rank = 0

    cache = file[:doc].search('div.ec_wise_ad')
    case cache
      when nil
        return result
      else
        cache[0].css('div.ec_resitem').each do |div|
          rank += 1
          url = div.css('span.ec_site').text
          result << {url: url, rank: rank}
        end
    end
    result
  end

  def _parse_ranks(file)
    pp 'parsing ranks...'
    n = 0
    result = []
    rank = 0

    pp file[:doc].request if file[:doc].search('div.resitem').empty?
    file[:doc].search('div.resitem').each do |div|
      rank += 1
      r = {}

      url = div.css('a')[0]
      title = ''
      url.children.each do |ele|
        title = title + ele.text if nil == ele['class']
      end

      pp n = n + 1
      r[:url] = url_follow(url)
      r[:site] = div.css('span.site').text
      r[:name] = div['tpl'] || 'ranks'
      r[:title] = title
      r[:srcid] = div['srcid']
      r[:rank] = rank

      result << r
    end
    pp 'ranks parsed.'
    result
  end

  def _parse_ads_bottom(file)
    result = []
    rank = 0

    cache = file[:doc].search('div.ec_wise_ad')
    case cache.to_a.length
      when 0,1
        return result
      else
        cache[1].css('div.ec_resitem').each do |div|
          rank += 1
          url = div.css('span.ec_site').text
          result << {url: url, rank: rank}
        end
    end
    result
  end

end