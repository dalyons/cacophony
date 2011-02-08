
require 'net/smtp'


class EmailNotifier

  def initialize(opts={})
    @opts = opts
    @from = opts['from'] || "Your sentient shell <shell@donotfearus.com>"
    @to = opts['to'] || "Puny human"
    @subject = opts['subject'] || "Job Complete"
    @server = opts['server'] || 'localhost'
    @port = opts['port'] || 25
    @username = opts['username'] || nil
    @password = opts['password'] || nil
    @method = opts['method'] || :plain
    @to_addresses = opts['to_address'].to_a
    @from_address = opts['from_address'] || ''
    @tls = opts['tls'] || false

  end

  def notify(message, title, data)

    details = message.dup
    details << "\n" + (data.any? ? "Last #{RESULTS_SIZE} lines...\n\n#{data.last(50).join}" : "No output.")

    @to_addresses.each do |address|

      msg = <<MESSAGE_END
From: #{@from}
To: #{@to}
Subject: #{title}: #{@subject}

#{details}

MESSAGE_END

      smtp = Net::SMTP.new @server, @port
      smtp.enable_starttls if @tls
      smtp.start(@server, @username, @password, @method.to_sym) do 
        smtp.send_message(msg, @from_address, address)
      end
    end
  end

end
