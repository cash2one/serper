require 'httparty'

module Serper
  class Crawler
    AllUserAgents = YAML.load(open(File.expand_path('../user_agents.yml',__FILE__)))

    def self.rand_ua
      AllUserAgents[rand(AllUserAgents.size)]
    end

    include HTTParty
    base_uri 'www.baidu.com'
    follow_redirects false
    headers "User-Agent" => self.rand_ua, "Referer" => 'http://www.baidu.com/'

    def self.get_serp(url,attrs={},retries = 3)
      self.new.get_serp(url,attrs,retries)
    end

    def self.get_rank_url(url)
      self.new.get_rank_url(url)
    end

    def get_rank_url(url)
      begin
        response = self.class.get(url)
      rescue StandardError => e
        pp url
        puts e.class
        puts e.message
        sleep(10)
        retry
      end
      response
    end

    def get_serp(url,attrs={},retries = 3)
      if retries > 0
        begin
          response = self.class.get(url,headers:attrs)
        rescue StandardError => e
          puts "The ERROR on: #{url}"
          puts e.class
          puts e.message
          sleep(10)
          retry
        end

        if response.code != 200
          puts response
          puts "Retry on URL: #{url}"
          sleep(rand(60)+1200)
          response = self.class.get_serp(url,retries - 1)
        end

        if response.nil?
          puts "Still error after 3 tries, sleep 3600s now."
          sleep(3600)
          response = self.class.get_serp(url)
        end

        ##Baidu Stopped response Content-Length in headers...
        #if response.headers['Content-Length'].nil?
        #  puts "Can't read Content-Length from response, retry."
        #  response = self.class.get_serp(url,retries-1)
        #end
        #
        #if response.headers['Content-Length'].to_i != response.body.bytesize
        #  issue_file = "/tmp/serper_crawler_issue_#{Time.now.strftime("%Y%m%d%H%M%S")}.html"
        #  open(issue_file,'w').puts(response.body)
        #  puts "Notice:"
        #  puts "Serper get an error when crawl SERP: response size (#{response.headers['Content-Length']}) not match body size."
        #  puts "Please see file #{issue_file} for body content."
        #  puts "Sleep 10s and retry"
        #  sleep(10)
        #  response = self.class.get_serp(url)
        #end

        response
      else
        nil
      end
    end

  end
end
