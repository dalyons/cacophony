#require all the notifiers
require 'cacophony/version'
Dir.glob(File.join(File.dirname(__FILE__), 'notifiers', '*.rb')) {|f| require f}


module Cacophony
  class Notifier

    def initialize(conf)
      raise 'need configuration hash' unless conf.is_a?(Hash) && conf.any?
      @conf = conf
    end

    def notify(title, message, data)

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
