class Serper::BaiduMobile

  #百度跳转跟踪原页面
  def url_follow(url)
    return nil if url.nil?
    begin
      url = URI.escape(url['href'])
      trans = HTTParty.get(url)
      url = trans.request.last_uri.to_s
      if /^http:\/\/m\.baidu\.com\// === url
        jumper = Nokogiri::HTML(trans).css('a#tc_ori')[0]
        unless jumper.nil? or jumper.name != 'a'
          url = URI.escape(jumper['href'])
          url = HTTParty.get(url).request.last_uri.to_s
        end
      end
    rescue StandardError,TimeoutError
      puts url
      puts $!.to_s
      url = URI.escape($!.to_s[/http:\/\/.+/]) if $!.to_s.start_with?('bad URI')
    end
    url
  end

  def _parse_ads_top(file)
    result = []
    rank = 0

    cache = file[:doc].search('div.ec_wise_ad')
    if cache.blank?
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
    puts 'parsing ranks...'
    n = 0
    result = []
    rank = 0

    file[:doc].search('div.resitem').each do |div|
      rank += 1
      r = {}

      url = div.css('a')[0]
      title = ''
      url.children.each do |ele|
        title = title + ele.text if nil == ele['class']
      end

      puts n = n + 1
      r[:url] = url_follow(url)
      r[:site] = div.css('span.site').text
      r[:name] = div['tpl'] || 'ranks'
      r[:title] = title
      r[:srcid] = div['srcid']
      r[:rank] = rank

      result << r
    end
    puts 'ranks parsed.'
    result
  end

  def _parse_ads_bottom(file)
    result = []
    rank = 0

    cache = file[:doc].search('div.ec_wise_ad')
    case cache.length
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