# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "cherrypicker/version"

Gem::Specification.new do |s|
  s.name        = "cherrypicker"
  s.version     = Cherrypicker::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Karl Entwistle"]
  s.email       = ["Karl@Entwistle.com"]
  s.homepage    = "http://karl.entwistle.info/"
  s.summary     = %q{Cherrypicker is Ruby Gem it lets you download from; Rapidshare and Hotfile}
#  s.description = %q{Cherrypicker is a upload/download for sites such as Rapidshare, Hotfile, Fileserv & Filesonic}

  s.rubyforge_project = "cherrypicker"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency('progressbar', '~> 0.9')
end
