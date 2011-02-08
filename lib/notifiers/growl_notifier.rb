begin
  require 'ruby-growl'
  GROWL_GEM = true
rescue LoadError
  GROWL_GEM = false
end

class GrowlNotifier
  def initialize(opts = {})
    @server = opts['server'] || '127.0.0.1'
    @sticky = opts['sticky'] || false
    @use_growl_gem = opts['use_growl_gem'] == false ? false : true 
    @output_lines = opts['output_lines'] || 2
  end

  def notify(message, title = '', data = [])
    msg = message.dup
    if data.any?
      msg << "\n\n" 
      #msg <<  "......#{data.length - @output_lines} more lines\n"  
      #(@output_lines - 1).downto(0).each{|i| msg << "#{data.length - i}: #{data[i]}"}
      data.last(@output_lines).each_with_index{|line,i| msg << "#{data.length - i}: #{line}"}
      msg <<  "......#{data.length - @output_lines} more lines"  
    end
    (@use_growl_gem && GROWL_GEM) ? notify_via_gem(msg, title) : notify_via_binary(msg, title)
  end

 private 
  def notify_via_gem(message, title)
    growl = Growl.new "127.0.0.1", "ruby-growl",["ruby-growl_Notification"]
    growl.notify "ruby-growl_Notification", title, message
  end

  def notify_via_binary(message, title)
    growl_bin = File.join(GEM_PATH, 'bin', 'growlnotify')
    system %{#{growl_bin} -m "#{msg}" "#{title}" #{"-s" if @sticky}}
  end
end
