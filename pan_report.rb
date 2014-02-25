#!/usr/bin/env ruby

require "net/https"
require 'optparse'
require "uri"
require 'pp'
Signal.trap(:INT) { puts "Cancelled"; exit 1 }

def request(method, url, params=nil)
  uri = URI.parse(url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  request = if method == 'get'
              Net::HTTP::Get.new(uri.request_uri)
            elsif method == 'post'
              Net::HTTP::Post.new(uri.request_uri)
            end

  request.set_form_data(params) if params
  res = http.request(request)
  res
end

def read_key
  lines = []
  key = ''
  need_update_cache = nil

  if $options[:cache] and File.readable?($options[:cache])
    lines = File.readlines($options[:cache])
    found = lines.detect do |line|
      line.split.first == $options[:device]
    end
    if found
      key = found.split.last
    end
  end

  if key.empty?
    warn 'keygen start'
    key = keygen
    warn 'keygen finish'
    need_update_cache = true
  end

  if $options[:cache] and need_update_cache
    File.open($options[:cache], 'w') do |io|
      io.puts (lines << "#{$options[:device]} #{key}")
    end
  end

  key
end

def keygen
  api_base = "https://#{$options[:device]}/api"
  url = "#{api_base}/?type=keygen&user=#{$options[:user]}&password=#{$options[:password]}"
  body = request('get', url ).body
  if body =~ /<key>(.*)<\/key>/
    $1
  else
    nil
  end
end

def main
  api_key = read_key
  if api_key.to_s.empty?
    warn 'failed to read api_key'
    exit 1
  end

  api_base = "https://#{$options[:device]}/api"
  xpath = if $options[:vsys]
            "/config/devices/entry/vsys/entry[@name='#{$options[:vsys]}']/reports"
          else
            "/config/shared/reports"
          end

  case $options[:action]
  when 'get', 'show' then
    url = "#{api_base}/?type=config&action=#{$options[:action]}&xpath=#{xpath}&key=#{api_key}"
    response = request('get', url)
    if response.body =~ /<result.*?><reports.*?>(.*)<\/reports><\/result>/m
      puts $1
    else
      warn "No report found or Error\n\n"
      warn response.body
    end

  when 'delete' then
    puts "[CAUTION] all report definition will be deleted"
    puts "CTRL-C for cancel"
    print "Press 'Enter' to continue: "
    STDIN.readline.chomp

    url = "#{api_base}/?type=config&action=#{$options[:action]}&xpath=#{xpath}&key=#{api_key}"
    puts request('get', url ).body

  when 'set' then
    response = request('post', api_base, {
      'type'    => 'config',
      'action'  => 'set',
      'xpath'   => xpath,
      'key'     => api_key,
      'element' => File.read($options[:file]),
    })
    puts response.body
  end
end

$options = {}
optparse = OptionParser.new do |opts|
  opts.on('-h', '--help', 'Display this screen' ) do
    puts opts
    puts <<-EOS

    # NOTE
    get:   candidate config
    show:  running config

    EOS
    exit
  end
  opts.on( '-a', "--action 'get|show|set|delete'", "action" ) do |action|
    $options[:action] = action
  end
  opts.on( '-c', "--cache FILE", "api_key cache_file" ) do |cache|
    $options[:cache] = cache
  end
  opts.on( '-d', "--device DEVICE_IP", "target device" ) do |device|
    $options[:device] = device
  end
  opts.on( '-f', '--file FILE', "xml file to be set" ) do |file|
    $options[:file] = file
  end
  opts.on('--vsys vsys', "target vsys (ex) vsys1" ) do |vsys|
    $options[:vsys] = vsys
  end
  opts.on( '-u', '--user user', "uesrname" ) do |user|
    $options[:user] = user
  end
  opts.on( '-p', '--password password', "password" ) do |password|
    $options[:password] = password
  end
end

begin
  optparse.parse!
rescue OptionParser::ParseError => err
  $stderr.puts err.message
  $stderr.puts optparse.help
  exit 1
end

options_default = {
  :user     => 'admin',
  :password => 'admin',
}
$options.update(options_default) { |k, v1, v2| v1 }

[:action, :device].each do |key|
  if not $options.has_key?(key) or not $options[key]
    $stderr.puts "\n'#{key}' required\n\n"
    $stderr.puts optparse.help
    exit 1
  end
end
if $options[:action] == 'set'
  if not $options[:file] or not File.readable?($options[:file])
    $stderr.puts "\nmissing file to set\n\n"
    $stderr.puts optparse.help
    exit 1
  end
end

main
