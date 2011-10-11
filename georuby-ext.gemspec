# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "georuby-ext"
  s.version     = "0.0.1"
  s.authors     = ["Alban Peignier"]
  s.email       = ["alban.peignier@dryade.net"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "georuby-ext"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec"
  s.add_development_dependency "rake"
  s.add_development_dependency "guard"
  s.add_development_dependency "rcov"

  s.add_runtime_dependency "GeoRuby"
  s.add_runtime_dependency "geokit"
  s.add_runtime_dependency "rgeo"
  s.add_runtime_dependency "proj4rb"

  s.add_runtime_dependency "activesupport"
end
