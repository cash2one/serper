require "serper/version"
require "serper/parser"
require "serper/analyser"

module Serper
  ENGINES = {
      :baidu => Baidu = Class.new,
      :baidu_mobile => BaiduMobile = Class.new,
      :qihu360 => Qihu360 = Class.new
  }

  ENGINES.keys.each do |engine_name|
    %w{crawler parser weight}.each do |part|
      require File.expand_path("../serper/#{engine_name}/#{part}.rb",__FILE__)
    end
  end

  def self.search(engine_name,keyword,page=1)
    serp = Parser.new(engine_name,keyword,page)
    serp.search
    serp
  end

  def self.analyse(connection)
    Analyser.new(connection)
  end
end