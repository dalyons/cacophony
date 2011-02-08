#!/usr/bin/ruby
#
require 'rubygems'
require 'yaml'
require 'trollop'
require 'fcntl'

#resolve symlinks FIX WHEN IN GEM
THIS_FILE = File.symlink?(__FILE__) ? File.readlink(__FILE__) : __FILE__
GEM_PATH = File.dirname(THIS_FILE) 
Dir.glob(File.join(GEM_PATH , 'notifiers', '*.rb')) {|f| require f}

RESULTS_SIZE = 50
DEFAULT_MSG = 'Task finished!'

opts = Trollop::options do 
  version "Cacophony v0.1 (c) 2011 David Lyons"
  banner <<-EOS
Desc goes here
EOS
  opt :message, "The message to send via the notifiers", :short => 'm', :type => String, :default => DEFAULT_MSG
  opt :title, "The title/subject to attach to messages", :short => 't', :type => String, :default => 'Noisy Notifier'
  opt :conf_file, "Alternate location of config file (default: ~/.noisy_notifier)", :short => 'c', :type => String
end
Trollop::die :conf_file, "must exist(try creating  ~/.noisy_notifier)" unless File.exist?(opts[:conf_file]) if opts[:conf_file]

CONF_FILE_PATH = opts[:conf_file] || File.join(File.expand_path('~'), '.noisy_notifier')
begin
  CONFIG = YAML.load_file(CONF_FILE_PATH)
rescue
  Trollop::die "could not load config file: #{CONF_FILE_PATH}"
end

output = []


if STDIN.fcntl(Fcntl::F_GETFL, 0) == 0
  ARGF.each do |line| 
    puts line
    output << line
  end
else
  #output << ''
end

threads = []

message = (opts[:message] == DEFAULT_MSG && m =  ARGV.shift) ? m : opts[:message]
title = opts[:title]

CONFIG.each do |notifier_type, opts|
  threads << Thread.new do
    begin
      klass = Object.const_get(notifier_type.split('_').map(&:capitalize).join)
    rescue 
        raise "Invalid configuration option(s): #{notifier_type}"
    end
    notifier = klass.new(opts || {} )
    notifier.notify(message, title, output)
  end
end


threads.each{|t| t.join}
