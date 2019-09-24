#! /usr/bin/env ruby
# show assets with duplicate MAC addresses.
# optionally restrict to a specific rack_position pattern
# output format is:
# duplicate-mac-addr asset-tag asset-tag

require 'collins_auth'

collins = Collins::Authenticator.setup_client

rack = ARGV[0] || 'ewr01-'
page_size = 100
page = 0
macs = {}
total_assets = 0

seen = {}

loop do
  assets = collins.find(
    :query => 'Status!=Decommissioned',
    :rack_position => rack,
    :type => 'SERVER_NODE',
    :size => page_size,
    :PAGE => page
  )
  break if assets.nil? or assets.empty?
  total_assets += assets.size

  #puts "got #{assets.size} assets"
  print '.'                     #show we are alive

  assets.each do |a|
    if seen[a.tag]
      $stderr.puts "asset #{a.tag} found before"
      next
    end
    seen[a.tag] = true
    a.mac_addresses.each do |m|
      if macs.has_key? m
        macs[m] << a.tag
      else
        macs[m] = [a.tag]
      end
    end
  end
  page += 1
end

puts "got #{total_assets} total number of assets"

total_dups = 0
macs.each do |m, ts|
  if ts.size > 1
    puts "#{m} #{ts.join(' ')}"
    total_dups += 1
  end
end
puts "found #{total_dups} duplicates"
