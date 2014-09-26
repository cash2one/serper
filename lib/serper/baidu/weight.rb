class Serper::Baidu
  def weight_config
    {
        :left_parts => [:ads_top,
                        :zhixin,
                        :ranks
        ],
        :right_parts => [:con_ar,
                         :ads_right
        ],

        :left_part_weight => 8,
        :right_part_weight => 2,

        :zhixin_weight => 2.5,
        :baiduopen_weight => 3,
        :rank_special_weight => 2,
        :con_ar_weight => 2
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
      mu = rank[:mu].to_s

      type = 'SEO'
      type = 'Special' if rank[:baiduopen]

      unless mu.empty?
        url = mu
        type = 'Special'
      end

      site = Serper::Helper.parse_site(url)
      subdomain = Serper::Helper.parse_subdomain(url)
      path = Serper::Helper.parse_path(url)

      name = rank[:tpl].to_s

      weight = 1.0/side_rank.to_f
      if type == 'Special'
        if rank[:baiduopen]
          weight = weight * weight_config[:baiduopen_weight].to_f
        else
          weight = weight * weight_config[:rank_special_weight].to_f
        end
      end

      part_rank = rank[:rank]

      result << {type: type, name: name, site: site, subdomain: subdomain, path: path, mu: mu, side_rank: side_rank, part_rank: part_rank, side_weight: weight}
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

  def _weight_of_con_ar(serp_result,side_rank)
    result = []
    serp_result[:con_ar].each.with_index do |con,i|
      side_rank += 1

      url = con[:data_click]['mu'].to_s
      type = 'Special'
      name = con[:tpl]
      site = Serper::Helper.parse_site(url)
      subdomain = Serper::Helper.parse_subdomain(url)
      path = Serper::Helper.parse_path(url)

      weight = 1.0 * weight_config[:con_ar_weight]
      result << {type: type, name: name, site: site, subdomain: subdomain, path: path, side_rank: side_rank, part_rank: i+1, side_weight: weight}
    end
    [result, side_rank]
  end

  def _weight_of_zhixin(serp_result,side_rank)
    result = []
    serp_result[:zhixin].each.with_index do |zhixin,i|
      side_rank += 1

      url = zhixin[:mu].to_s
      type = 'Special'
      name = zhixin[:tpl]
      site = Serper::Helper.parse_site(url)
      subdomain = Serper::Helper.parse_subdomain(url)
      weight = 1.0 * weight_config[:zhixin_weight]
      path = Serper::Helper.parse_path(url)

      result << {type: type, name: name, site: site, subdomain: subdomain, path: path, side_rank: side_rank, part_rank: i+1, side_weight: weight}
    end
    [result, side_rank]
  end
end