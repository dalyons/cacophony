# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "cacophony/version"

Gem::Specification.new do |s|
  s.name        = "cacophony"
  s.version     = Cacophony::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Dave Lyons"]
  s.email       = ["dalyons@gmail.com"]
  s.homepage    = "http://www.loadedfingers.com"
  s.summary     = %q{Broadcast messages from programs and the command line}
  s.description = %q{see summary}

  #s.rubyforge_project = "cacophony"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('yaml')
end
