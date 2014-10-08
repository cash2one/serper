class Serper::Baidu
  def _parse_ads_right(file)
    result = []
    rank = 0

    file[:doc].search('div#ec_im_container span a.c-icon.efc-cert').each do |div|
      rank += 1
      url = Addressable::URI.parse(Serper::Helper.parse_data_click(div['data-renzheng'])['identity']['a']['url']).query_values['wd'].to_s.sub('@v','') rescue ''
      result << {url: url, rank: rank}
    end
    result
  end

  def _parse_ads_top(file)
    result = []
    rank = 0

    file[:doc].search('div#content_left').first.children.each do |div|
      break if [1..3000].include?(div['id'].to_i)
      div.search('span a.c-icon.efc-cert').each do |div|
        rank += 1
        url = Addressable::URI.parse(Serper::Helper.parse_data_click(div['data-renzheng'])['identity']['a']['url']).query_values['wd'].to_s.sub('@v', '') rescue ''
        result << {url: url, rank: rank}
      end
    end
    result
  end

  def _parse_con_ar(file)
    result = []
    divs = file[:doc].search("div#content_right div#con-ar").first
    return [] if divs.nil?
    divs.children.each do |div|
      next unless div['class'].to_s.include?('result-op')
      result << {:tpl => div['tpl'],
                 :data_click => Serper::Helper.parse_data_click(div['data-click'])
      }
    end
    result
  end

  # def _parse_pinpaizhuanqu(file)
  #   part = file[:doc].search("div[@id='content_left']").first
  #   return false if part.nil?
  #
  #   part.children[2].name == 'script'
  # end

  def _parse_ranks(file)
    result = []
    part = file[:doc].css('div#content_left').first
    return result if part.nil?

    part.children.each do |table|
      next if table.nil?
      id = table['id'].to_i
      next unless id > 0 && id < 3000

      r = {:rank => id}

      r[:result_op] = table['class'].to_s.include?('result-op')

      r[:fk] = table['fk']

      r[:srcid] = table['srcid']

      r[:tpl] = table['tpl'] || 'ranks'

      r[:mu] = table['mu']

      url = table.css('h3 a').first
      unless url.nil?
        url = url['href']
        url = 'http:' + url unless /^http:/ === url
        sleep(rand)
        url = Serper::Crawler.get_rank_url(url).headers['location'] if url.include?('//www.baidu.com/link?')
      end
      r[:url] = url

      r[:title] = Serper::Helper.get_content_safe(table.search('h3'))

      r[:content] = Serper::Helper.get_content_safe(table.search('div.c-abstract'))

      table.search('a').each do |link|
        r[:baiduopen] = true if link['href'].to_s.include?('open.baidu.com')
      end
      r[:baiduopen] = false if r[:baiduopen].nil?

      result << r
    end
    result
  end

  # def _parse_related_keywords(file)
  #   result = []
  #   file[:doc].search('div[@id="rs"]').each do |rs|
  #     rs.css('a').each do |link|
  #       result << link.content
  #     end
  #   end
  #   result
  # end

  # def _parse_result_num(file)
  #   html = file[:html]
  #   str = html.scan(/百度为您找到相关结果(.*)个/).join
  #   str = str.gsub('约','')
  #   if str.include?('万')
  #     parts = str.split('万')
  #     result = parts[0].to_i * 10000 + parts[1].to_i
  #   else
  #     result = str.gsub(',', '').to_i
  #   end
  #
  #   result
  # end

  # def _parse_right_hotel(file)
  #   rh = file[:doc].search('div[@tpl="right_hotel"]')
  #   return nil if rh.nil?
  #
  #   rh = rh.first
  #   return nil if rh.nil?
  #   title = Serper::Helper.get_content_safe(rh.search('div.opr-hotel-title'))
  #
  #   {:title => title}
  # end

  # def _parse_right_personinfo(file)
  #   rp = file[:doc].search('div[@tpl="right_personinfo"]')
  #   return nil if rp.nil?
  #
  #   title = Serper::Helper.get_content_safe rp.search('span.opr-personinfo-subtitle-large')
  #   info_summary = Serper::Helper.get_content_safe rp.search('div.opr-personinfo-summary')
  #   info = Serper::Helper.get_content_safe rp.search('div.opr-personinfo-info')
  #   source = Serper::Helper.get_content_safe rp.search('div.opr-personinfo-source a')
  #
  #   return nil if title.nil? && info.nil? && source.nil?
  #   {:title => title, :info_summary => info_summary, :info => info, :source => source}
  # end

  # def _parse_right_relaperson(file)
  #   relapersons = file[:doc].search('div[@tpl="right_relaperson"]')
  #   return nil if relapersons.nil?
  #
  #   result = []
  #   relapersons.each do |rr|
  #     title = rr.search('div.cr-title/span').first
  #     title = title.content unless title.nil?
  #     r = []
  #     rr.search('p.opr-relaperson-name/a').each do |p|
  #       r << p['title']
  #     end
  #     result << {:title => title, :names => r}
  #   end
  #   result
  # end

  # def _parse_right_weather(file)
  #   rw = file[:doc].search('div[@tpl="right_weather"]')
  #   return nil if rw.nil?
  #
  #   rw = rw.first
  #   return nil if rw.nil?
  #
  #   title = Serper::Helper.get_content_safe(rw.search('div.opr-weather-title'))
  #   week = rw.search('a.opr-weather-week').first['href']
  #
  #   {:title => title, :week => week}
  # end

  def _parse_zhixin(file)
    result = []
    file[:doc].search("div#content_left .result-zxl").each do |zxl|
      result << {:id => zxl['id'],
                 :srcid => zxl['srcid'],
                 :fk => zxl['fk'],
                 :tpl => zxl['tpl'],
                 :mu => zxl['mu'],
                 :data_click => Serper::Helper.parse_data_click(zxl['data-click'])
      }
    end
    result
  end

end