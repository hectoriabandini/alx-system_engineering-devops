#!/usr/bin/env ruby

# Get the argument passed to the script
input_argument = ARGV[0]

# Define the regular expression
pattern = /School/

# Match the regular expression against the input
result = input_argument.scan(pattern).join

# Print the result
puts result
