# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "cacophony/version"

Gem::Specification.new do |s|
  s.name        = "cacophony"
  s.version     = Cacophony::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Dave Lyons"]
  s.email       = ["dalyons@gmail.com"]
  s.homepage    = "https://github.com/dalyons/cacophony"
  s.summary     = %q{Broadcast messages from programs and the command line}
  s.description = %q{Cacophony is a small program that broadcasts notifications via a variety of mechanisms, such as growl, email and twitter.
It is great for notifiying you(or others) when a long running task is complete.
It operates as a standalone executable, and it also can read from STDIN to pipe output from your tasks to the notifiers.
}

  #s.rubyforge_project = "cacophony"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('trollop')
end
