# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'serper/version'

Gem::Specification.new do |gem|
  gem.name          = "serper"
  gem.version       = Serper::VERSION
  gem.authors       = ["MingQian Zhang"]
  gem.email         = ["zmingqian@qq.com"]
  gem.description   = %q{Parse SERP result page.}
  gem.summary       = %q{SERP}
  gem.homepage      = "https://github.com/semseo/serper"
  gem.license       = "MIT"

#  gem.files         = `git ls-files`.split($/)
  gem.files	    =  Dir["{lib}/**/*.rb", "bin/*", "*.md","{lib}/**/*.yml"]
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency 'nokogiri'
  gem.add_runtime_dependency 'httparty'
  gem.add_runtime_dependency 'domainatrix'
  gem.add_runtime_dependency 'activerecord'
  gem.add_runtime_dependency 'docopt'
  gem.add_runtime_dependency 'ruby-progressbar'
end
