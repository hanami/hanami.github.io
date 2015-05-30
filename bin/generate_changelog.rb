#!/usr/bin/env ruby
require 'optparse'
require_relative '../lib/changelog'

if ARGV.empty?
  puts "Genereate weekly changelog since"
  puts "Usage: generate_changelog.rb [YYYY-MM-DD]"
  exit
end

from   = ARGV[0]

Lotus::Changelog.new(Date.parse(from)).generate_all