#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
require 'benchmark'
require_relative '../lib/grouping_assesment'

if ARGV.size != 2
  puts "Usage: #{$PROGRAM_NAME} <input_file.csv> <matching_type>"
  puts 'Available matching types: same_email, same_phone, same_email_or_phone'
  exit 1
end

input_file = ARGV[0]
matching_type = ARGV[1]

begin
  time_taken = Benchmark.realtime do
    GroupingAssessment.new(input_file, matching_type).group_records
  end
  puts "Execution time: #{time_taken.round(2)} seconds"
rescue StandardError => e
  puts "Error: #{e.message}"
  exit 1
end
