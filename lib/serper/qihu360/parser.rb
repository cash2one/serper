class Serper::Qihu360
  def _parse_ads_right(file)
    result = []
    rank = 0

    file[:doc].search('ul#rightbox.result').css('li').each do |li|
      rank += 1
      url = li.css('cite').text.downcase
      result << {url: url, rank: rank}
    end
    result
  end

  def _parse_ads_top(file)
    result = []
    rank = 0

    file[:doc].search('ul#e_idea_pp').css('li').each do |li|
      rank += 1
      url = li.css('cite').text.downcase
      result << {url: url, rank: rank}
    end
    result
  end

  def _parse_mohe_right(file)
    result = []
    rank = 0
    file[:doc].search('div#m-mohe-right').css('div.mh-box').each do |div|
      rank += 1
      title = Serper::Helper.parse_data_click(div['data-mgd'])['title']
      result << {title: title, rank: rank}
    end
    result
  end

  def _parse_ranks(file)
    result = []
    rank = 0

    file[:doc].search('ul#m-result').children.each do |li|
      rank += 1
      r = {}
      r[:rank] = rank
      r[:name] = 'ranks'
      li.children.each do |row|
        case row['class']
          when /^res-title/
            r[:title] = row.text.strip
            r[:url] = row.css('a')[0]['href']
          when /^res-desc/
            r[:desc] = row.text.strip
          when /^res-rich/
            r[:name] = 'rich'
          when /^g-mohe/
            begin
              r[:name] = 'mohe'
              r[:title] = row.css('h3').text.strip
              r[:url] = row.css('h3 a')[0]['href']
              r[:desc] = ''
            rescue
              r[:name] = 'mohe'
              r[:title] = 'error'
              r[:url] = 'http://error.com/'
              r[:desc] = ''
              open("/tmp/serper_issue_mohe_#{Time.now.strftime("%Y%m%d%H%M%S")}.html",'w').puts(file[:html])
            end
          else
        end
      end
      result << r
    end
    result
  end
end