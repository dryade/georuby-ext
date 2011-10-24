# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "georuby-ext"
  s.version     = "0.0.1"
  s.authors     = ["Marc Florisson", "Luc Donnet", "Alban Peignier"]
  s.email       = ["marc@dryade.net", "luc@dryade.net", "alban@dryade.net"]
  s.homepage    = "http://github.com/dryade/georuby-ext"
  s.summary     = %q{Extension to Ruby geometry libraries}
  s.description = %q{Use together GeoRuby, rgeo, geokit, proj4j (and others)}

  s.rubyforge_project = "georuby-ext"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec"
  s.add_development_dependency "rake"
  s.add_development_dependency "guard"
  s.add_development_dependency "rcov"

  s.add_runtime_dependency "georuby"
  s.add_runtime_dependency "geokit"
  s.add_runtime_dependency "rgeo"
  s.add_runtime_dependency "proj4rb"
  s.add_runtime_dependency "json_pure"

  s.add_runtime_dependency "activesupport"
end
