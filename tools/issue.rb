#!/usr/bin/env ruby
#
# Helper Script to access the CFME REST API
#
# Makes use of the Trollop and Faraday Client Gems
#   gem install trollop
#   gem install faraday
#
# Run with --help to see the usage.
#

require 'uri'
require 'json'
require 'trollop'
require 'faraday'

api_cmd   = File.basename($PROGRAM_NAME)
api_ver   = "1.0"
cmd_title = "CFME BugZilla REST API Access Script"

sep       = "_" * 60
prefix    = "/issues"
ctype     = "application/json"
data      = ""

def msg_exit(msg, exit_code = 1)
  puts msg
  exit exit_code
end

def json_pretty(json)
  puts JSON.pretty_generate(JSON.parse(json))
rescue
  puts json
end

path      = ""
params    = {}

methods   = {
  "get"  => "get",
  "post" => "post",
}

actions              = methods.keys
methods_needing_data = %w(post)
sub_commands         = actions
api_parameters       = %w(attributes limit offset sort_by sort_order sqlfilter bug_ids expand search)

opts = Trollop.options do
  version "#{api_cmd} #{api_ver} - #{cmd_title}"
  banner <<-EOS
#{api_cmd} #{api_ver} - #{cmd_title}

Usage: #{api_cmd} [options] <action> [parameters] [resource]

            action - is the action to use for the request, i.e. get, post

            [parameters] include: #{api_parameters.join(", ")}
                         specify --help for additional help

            [resource] - is the optional resource i.e. issues

#{api_cmd} options are:
EOS
  opt :verbose,    "Verbose mode, show details of the communication",
      :default => false,                    :short => '-v'
  opt :url,        "Base URL of CFME to access",
      :default => "http://localhost:5000",  :short => '-l'
  opt :user,       "User to authentication as",
      :default => "",                       :short => '-u'
  opt :password,   "Password for user specified to authenticate as",
      :default => "",                       :short => '-p'
  opt :format,     "How to format Json, pretty|none",
      :default => "pretty",                 :short => '-f'
  opt :inputfile,  "File to use as input to the POST methods",
      :default => "",                       :short => '-i'
  stop_on sub_commands
end

unless opts[:inputfile].empty?
  Trollop.die :inputfile, "File specified #{opts[:inputfile]} does not exist" unless File.exists?(opts[:inputfile])
end

begin
  URI.parse(opts[:url])
rescue
  Trollop.die :url, "Invalid URL syntax specified #{opts[:url]}"
end

action = ARGV.shift
Trollop.die "Must specify an action" if action.nil?

api_params = Trollop.options do
  api_parameters.each { |param| opt param.intern, param, :default => "" }
end
api_parameters.each { |param| params[param] = api_params[param.intern] unless api_params[param.intern].empty? }

resource = ARGV.shift
resource = "/" + resource             if !resource.nil? && resource[0] != "/"
resource = resource.gsub(prefix, '')  unless resource.nil?

method = methods[action]
msg_exit("Unsupported action #{action} specified") if method.nil?

if methods_needing_data.include?(method)
  if opts[:inputfile].empty?
    puts "Enter data to send with request:"
    puts "Terminate with \"\" or \".\""
    s = gets
    loop do
      break if s.nil?
      s = s.strip
      break if s == "." || s == ""
      data << s.strip
      s = gets
    end
  else
    data = File.read(opts[:inputfile])
  end

  msg_exit("Action #{action} requires data to be specified") if data.empty?
end

conn = Faraday.new(:url => opts[:url]) do |faraday|
  faraday.request(:url_encoded)               # form-encode POST params
  faraday.response(:logger) if opts[:verbose] # log requests to STDOUT
  faraday.adapter(Faraday.default_adapter)    # make requests with Net::HTTP
  faraday.basic_auth(opts[:user], opts[:password]) unless opts[:user].empty?
end

path = prefix

collection = ""
item = ""
unless resource.nil?
  path << resource
  rscan = resource.scan(/[^\/]+/)
  collection, item = rscan[0..1]
end

if opts[:verbose]
  puts sep
  puts "Connection Endpoint: #{opts[:url]}"
  puts "Action:              #{action}"
  puts "HTTP Method:         #{method}"
  puts "Resource:            #{resource}"
  puts "Collection:          #{collection}"
  puts "Item:                #{item}"
  puts "Parameters:"
  params.keys.each { |k| puts "#{' ' * 21}#{k} = #{params[k]}" }
  puts "Path:                #{path}"
  puts "Data:                #{data}"
end

begin
  response = conn.send(method) do |req|
    req.url path
    req.headers[:content_type]  = ctype
    req.headers[:accept]        = ctype
    req.params.merge!(params)
    req.body = data if methods_needing_data.include?(method)
  end
rescue
  msg_exit("\nFailed to connect to #{opts[:url]}")
end

if opts[:verbose]
  puts sep
  puts "Response Headers:"
  puts response.headers

  puts sep
  puts "Response Body:"
end

if response.body
  body = response.body.strip
  if opts[:format] == "pretty"
    puts json_pretty(body) unless body.empty?
  else
    puts body
  end
end

exit response.status >= 400 ? 1 : 0
