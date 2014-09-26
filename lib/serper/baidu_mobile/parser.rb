class Serper::BaiduMobile

  def _parse_ads_top(file)
    result = []
    rank = 0

    file[:doc].search('div.ec_wise_ad')[0].css('div.ec_resitem').each do |div|
      rank += 1
      url = div.css('span.ec_site').text
      result << {url: url, rank: rank}
    end
    result
  end

  def _parse_ranks(file)
    result = []
    rank = 0

    file[:doc].search('div.resitem').each do |div|
      rank += 1
      r = {}

      url = div.css('a')[0]
      r[:site] = div.css('span.site').text
      case url
        when nil
          r[:url] = r[:site]
        else
          sleep(rand)
          r[:url] = HTTParty.get(url['href']).request.last_uri.to_s
      end

      title = ''
      url.children.each do |ele|
        title = title + ele.text if nil == ele['class']
      end

      r[:name] = div['tpl'] || 'ranks'
      r[:title] = title
      r[:srcid] = div['srcid']
      r[:rank] = rank

      result << r
    end
    result
  end

  def _parse_ads_bottom(file)
    result = []
    rank = 0

    file[:doc].search('div.ec_wise_ad')[1].css('div.ec_resitem').each do |div|
      rank += 1
      url = div.css('span.ec_site').text
      result << {url: url, rank: rank}
    end
    result
  end

end