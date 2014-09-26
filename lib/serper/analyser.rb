require 'active_record'
require 'csv'
require 'date'
require 'yaml'
require 'ruby-progressbar'

module Serper
  class Analyser
    def initialize(connection)
      ActiveRecord::Base.establish_connection(connection)
    end

    def import_keywords(file)
      CSV.foreach(file) do |l|
        Keyword.find_or_create_by(:term => l[0]) do |r|
          r.pv = l[1]
          r.category = l[2]
          r.url_type = l[3]
          r.url_id = l[4]
        end
      end
    end

    def run(date=Date.today,skip=true)
      puts "Serper Analyser on #{date}"
      ENGINES.keys.each do |engine_name|
        puts engine_name
        search_engine(engine_name,date,skip)
      end
    end

    def search_engine(engine_name,date,skip=true)
      p = ProgressBar.create(:title => "Searching #{engine_name} - #{date}", :total => Keyword.all.count, :format => '%t (%c/%C) %a %E |%w')
      Keyword.all.each do |k|
        check_exists = Weight.where(:engine => engine_name, :date => date, :keyword_id => k.id)
        if check_exists.any?
          if skip
            next
          else
            check_exists.destroy_all
          end
        end

        serp = Serper.search(engine_name,k.term)
        serp.weights.each do |w|
          Weight.create(:date => date,
                        :keyword_id => k.id,
                        :engine => engine_name,
                        :side => w[:side],
                        :part => w[:part],
                        :source => w[:type],
                        :name => w[:name],
                        :site => w[:site],
                        :subdomain => w[:subdomain],
                        :path => w[:path],
                        :part_rank => w[:part_rank],
                        :side_rank => w[:side_rank],
                        :side_weight => w[:side_weight],
                        :weight => w[:weight]
          )
        end

        p.increment
      end
    end

    def migrate!
      ActiveRecord::Schema.define do
        create_table :serper_keywords do |t|
          t.string :term
          t.integer :pv
          t.string :category
          t.string :url_type
          t.integer :url_id

          t.timestamps

          t.index :term
        end

        create_table :serper_weights do |t|
          t.date :date
          t.string :engine
          t.integer :keyword_id
          t.string :side # Left Right
          t.string :part
          t.string :source # SEO SEM Special
          t.string :name
          t.string :site
          t.string :subdomain
          t.string :path
          t.integer :part_rank
          t.integer :side_rank
          t.float :side_weight
          t.float :weight

          t.timestamps

          t.index [:date, :engine, :keyword_id, :side, :side_rank], name: 'weights_pk_index'
        end
      end
    end

    class Keyword < ActiveRecord::Base
      self.table_name = 'serper_keywords'
    end

    class Weight < ActiveRecord::Base
      self.table_name = 'serper_weights'
    end
  end
end
