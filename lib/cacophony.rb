require 'yaml'
require 'cacophony/version'
#require all the notifiers
Dir.glob(File.join(File.dirname(__FILE__), 'notifiers', '*.rb')) {|f| require f}


module Cacophony
  DEFAULT_CONF_PATH = '~/.cacophony'

  class Notifier

    def initialize(config_hash_or_filename = nil)
      if config_hash_or_filename.is_a?(Hash)
        @conf = config_hash_or_filename
      elsif config_hash_or_filename.nil? || config_hash_or_filename.is_a?(String)
        config_hash_or_filename ||= DEFAULT_CONF_PATH
        path = File.expand_path(config_hash_or_filename)
        begin 
          @conf = YAML.load_file(path)
        rescue 
          raise "#{$!} couldn't read Cacophony config file from #{path} "
        end

      else
        raise 'invalid config parameter.'
      end
    end

    def notify(title, message, data = [])

      threads = []
      @conf.each do |notifier_type, opts|
        begin
          klass = Object.const_get(notifier_type.split('_').map(&:capitalize).join)
        rescue 
            raise "Invalid configuration option(s): #{notifier_type}"
        end

        threads << Thread.new do
          notifier = klass.new(opts || {} )
          puts "Cacophony broadcasting via #{notifier_type.split('_').map(&:capitalize).join(' ')}"
          notifier.notify(message, title, data)
        end
      end

      threads.each{|t| t.join}
    end
  end
end
