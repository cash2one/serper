require 'domainatrix'

module Serper
  module Helper
    class << self
      # get content safe from nokogiri search reasult
      def get_content_safe(noko)
        return nil if noko.nil?
        return nil if noko.empty?
        noko.first.content.strip
      end

      # parse data click value from baidu div property,
      # which is a JSON like format
      def parse_data_click(str)
        JSON.parse(str
                     .gsub("'",'"')
                     .gsub(/({|,)([a-zA-Z0-9_]+):/, '\1"\2":')
                     #.gsub(/'*([a-zA-Z0-9_]+)'*:/, '"\1":')
                     #.gsub(/:'([^(',\")]*)'(,|})/,':"\1"\2')
                   )
      end

      # normalize weight of given data,
      # the data must be a hash array structure.
      # for example : [{a: 1, b: 2}, {a: 2, b: 3}]
      def normalize(data,weight_col=:weight,normalized_col=:normalized_weight)
        total_weight = data.reduce(0.0) {|sum,d| sum += d[weight_col].to_f}
        data.each do|d|
          d[normalized_col] = d[weight_col].to_f/total_weight
        end
        data
      end

      def parse_site(url)
        begin
          url = Domainatrix.parse(url.to_s)
          site = url.domain + '.' + url.public_suffix
        rescue Exception => e
          puts "parse_site from url error:"
          puts url
          puts e.class
          puts e.message
          site = ''
        end
        site
      end

      def parse_subdomain(url)
        begin
          url = Domainatrix.parse(url.to_s)
          subdomain = url.subdomain
        rescue Exception => e
          puts "parse_site from url error:"
          puts url
          puts e.class
          puts e.message
          subdomain = ''
        end
        subdomain
      end

      def parse_path(url)
        begin
          url = Domainatrix.parse(url.to_s)
          path = url.path
        rescue Exception => e
          puts "parse_site from url error:"
          puts url
          puts e.class
          puts e.message
          path = ''
        end
        path
      end

    end
  end
end
