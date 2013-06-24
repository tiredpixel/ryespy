#!/usr/bin/env ruby

$stdout.sync = true

require 'optparse'

require File.expand_path(File.dirname(__FILE__) + '/../lib/ryespy')


# = Parse opts

options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: ryespy [options]"
  
  opts.separator ""
  opts.separator "Listener:"
  
  opts.on("-l", "--listener LISTENER", [:imap, :ftp], "Listener (imap|ftp)") do |o|
    options[:listener] = o
  end
  
  opts.separator ""
  opts.separator "Polling:"
  
  opts.on("-e", "--[no-]eternal", "Run eternally") do |o|
    options[:eternal] = o
  end
  
  opts.on("--polling-interval [N]", Integer, "Poll every N seconds when --eternal") do |o|
    options[:polling_interval] = o
  end
  
  opts.separator ""
  opts.separator "Redis:"
  
  opts.on("--redis-url [URL]", "Connect Redis to URL") do |o|
    options[:redis_url] = o
  end
  
  opts.on("--redis-ns-ryespy [NS]", "Namespace Redis 'ryespy:' as NS") do |o|
    options[:redis_ns_ryespy] = o
  end
  
  opts.separator ""
  opts.separator "Other:"
  
  opts.on("-v", "--[no-]verbose", "Be somewhat verbose") do |o|
    options[:verbose] = o
  end
  
  opts.on_tail("--help", "Show this message") do
    puts opts
    exit
  end
  
  opts.on_tail("--version", "Show version") do
    puts "Ryespy version:#{Ryespy::VERSION}"
    exit
  end
end.parse!


# = Configure

Ryespy.configure do |c|
  c.log_level = 'DEBUG' if options[:verbose]
  
  params = [
    :polling_interval,
    :redis_url,
    :redis_ns_ryespy,
  ]
  
  params.each { |s| c.send("#{s}=", options[s]) unless options[s].nil? }
end

@logger = Ryespy.logger


# = Main loop

loop do
  # TODO: Poll listener.
  
  break unless options[:eternal]
  
  @logger.debug { "Snoring for #{Ryespy.config.polling_interval} s" }
  
  sleep Ryespy.config.polling_interval # sleep awhile (snore)
end
