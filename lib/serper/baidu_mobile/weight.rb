class Serper::BaiduMobile
  def weight_config
    {
        :left_parts => [:ads_top,:ranks,:ads_bottom],
        :right_parts => [],
        :left_part_weight => 10,
        :right_part_weight => 0,
        :baiduopen_weight => 3,
        :rank_special_weight => 2
    }
  end

  # _weight_of_*** functions
  # return a hash array
  # each hash includes: type, name, site, weight

  def _weight_of_ranks(serp_result,side_rank)
    result = []
    serp_result[:ranks].each.with_index do |rank,i|
      side_rank += 1

      url = rank[:url].to_s

      type = 'SEO'
      type = 'Special' if rank[:name] == 'ranks'

      site = Serper::Helper.parse_site(url)
      subdomain = Serper::Helper.parse_subdomain(url)
      path = Serper::Helper.parse_path(url)

      name = rank[:name].to_s

      weight = 1.0/side_rank.to_f
      unless name == 'ranks'
        if rank[:site] == 'open.baidu.com'
          weight = weight * weight_config[:baiduopen_weight].to_f
        else
          weight = weight * weight_config[:rank_special_weight].to_f
        end
      end

      part_rank = rank[:rank]

      result << {type: type, name: name, site: site, subdomain: subdomain, path: path, side_rank: side_rank, part_rank: part_rank, side_weight: weight}
    end
    [result, side_rank]
  end

  def _weight_of_ads_top(serp_result,side_rank)
    result = []
    serp_result[:ads_top].each.with_index do |ad,i|
      side_rank += 1

      url = ad[:url].to_s
      type = 'SEM'
      name = ''
      site = Serper::Helper.parse_site(url)
      subdomain = Serper::Helper.parse_subdomain(url)
      path = Serper::Helper.parse_path(url)

      part_rank = ad[:rank]

      weight = 1.0/side_rank.to_f
      result << {type: type, name: name, site: site, subdomain: subdomain, path: path, side_rank: side_rank, part_rank: part_rank, side_weight: weight}
    end
    [result, side_rank]
  end

  def _weight_of_ads_bottom(serp_result,side_rank)
    result = []
    serp_result[:ads_top].each.with_index do |ad,i|
      side_rank += 1

      url = ad[:url].to_s
      type = 'SEM'
      name = ''
      site = Serper::Helper.parse_site(url)
      subdomain = Serper::Helper.parse_subdomain(url)
      path = Serper::Helper.parse_path(url)

      part_rank = ad[:rank]

      weight = 1.0/side_rank.to_f
      result << {type: type, name: name, site: site, subdomain: subdomain, path: path, side_rank: side_rank, part_rank: part_rank, side_weight: weight}
    end
    [result, side_rank]
  end

end