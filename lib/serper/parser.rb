# -*- coding: utf-8 -*-
require 'nokogiri'
require 'uri'
require 'json'
require 'serper/crawler'
require 'serper/helper'

module Serper
  class Parser
    attr_reader :engine_name, :keyword, :page, :html, :doc, :result

    def initialize(engine_name,keyword,page=1)
      @engine_name = engine_name
      @engine = ENGINES[@engine_name].new
      @keyword = keyword
      @page = page
    end

    def search
      html = @engine.search(@keyword,@page)
      parse html
    end

    def parse(html)
      html = html.encode!('UTF-8','UTF-8',:invalid => :replace)
      @file = Hash.new
      @result = Hash.new

      @file[:html] = html
      @file[:doc] = Nokogiri::HTML(html)

      @engine.methods.each do |m|
        next unless m =~ /^_parse_/
        begin
          @result[m.to_s.sub('_parse_','').to_sym] = @engine.send m,@file
        rescue Exception => e
          issue_file = "/tmp/serper_issue_#{Time.now.strftime("%Y%m%d%H%M%S")}.html"
          open(issue_file,'w').puts(html)
          puts "Notice:"
          puts "Serper gem have a bug, please email to zmingqian@qq.com to report it."
          puts "Please attach file #{issue_file} in the email and the error information below, thanks!"
          puts e.message
          puts e.inspect
          puts e.backtrace
          raise "Serper Parser Get An Error!"
        end
      end

      @result
    end


    def weights
      result = []
      [:left,:right].each do |side|
        side_rank = 0

        @engine.weight_config["#{side}_parts".to_sym].each do |part|
          rs,side_rank = @engine.send("_weight_of_#{part}",@result,side_rank)
          raise '!Weight Error!' if rs.nil?

          rs.each do |r|
            r[:side] = side.to_s
            r[:part] = part

            r[:weight] = r[:weight].to_f * @engine.weight_config["#{side}_part_weight".to_sym].to_f
            result << r
          end
        end
      end
      Serper::Helper.normalize(result,:side_weight,:weight)
    end
  end
end
