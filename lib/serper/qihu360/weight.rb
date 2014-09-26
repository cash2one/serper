class Serper::Qihu360
  def weight_config
    {
        :left_parts => [:ads_top,:ranks],
        :right_parts => [:mohe_right,:ads_right],
        :mohe_weight => 2.5,
        :rich_weight => 2,
        :mohe_right_weight => 2,
        :left_part_weight => 8,
        :right_part_weight => 2
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
      type = 'Special' if rank[:name] == 'mohe'

      site = Serper::Helper.parse_site(url)
      subdomain = Serper::Helper.parse_subdomain(url)
      path = Serper::Helper.parse_path(url)

      name = rank[:name].to_s

      weight = 1.0/side_rank.to_f
      case name
        when 'mohe'
          weight = weight * weight_config[:mohe_weight].to_f
        when 'rich'
          weight = weight * weight_config[:rich_weight].to_f
        else
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

  def _weight_of_ads_right(serp_result,side_rank)
    result = []
    serp_result[:ads_right].each.with_index do |ad,i|
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

  def _weight_of_mohe_right(serp_result,side_rank)
    result = []
    serp_result[:mohe_right].each.with_index do |mohe,i|
      side_rank += 1
      part_rank = mohe[:rank]

      type = 'Special'
      name = ''

      weight = 1.0 * weight_config[:mohe_right_weight].to_f
      result << {type: type, name: name, side_rank: side_rank, part_rank: part_rank, side_weight: weight}
    end
    [result, side_rank]
  end

end