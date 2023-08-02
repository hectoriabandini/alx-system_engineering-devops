#!/usr/bin/env ruby

# Get the argument passed to the script (log line)
log_line = ARGV[0]

# Define the regular expressions to extract sender, receiver, and flags
sender_regex = /\[from:(.*?)\]/
receiver_regex = /\[to:(.*?)\]/
flags_regex = /\[flags:(.*?)\]/

# Extract the sender, receiver, and flags from the log line
sender = log_line.match(sender_regex)&.captures&.first
receiver = log_line.match(receiver_regex)&.captures&.first
flags = log_line.match(flags_regex)&.captures&.first

# Output the extracted information in the required format
puts "#{sender},#{receiver},#{flags}"
