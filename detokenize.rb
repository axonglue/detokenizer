#!/usr/bin/env ruby
#----------------------------------------------------------------------------
#
# NAME          : detokenize.rb
#
# PURPOSE       : Replace Tokens (RegEx /@[A-Z_0-9]*@/) with attributes
#
# DATE          : Mar 2014
#
# VERSION       : 1.1.0
#
# NOTES         :
#
#----------------------------------------------------------------------------

require 'optparse'

def detoken(input_file,output_file,attributes_file)
    attributes = Hash.new

    # Load the file into an array
    lines = File.readlines(input_file)

    # Create an hash from the attribute list file
    File.open(attributes_file).each do |line|
        if line=~ /=/
            values = line.split(/=/)
            attributes[values[0]] = values[1].strip
        end 
    end
    
    # Replace found Tokens
    for i in 0..(lines.count-1) do
        tokens = lines[i].scan(/@[A-Z_0-9]*@/)
        for token in tokens do
            key = token.gsub(/@/,'')
            value = attributes[key]
            if value != nil
                lines[i] =  lines[i].sub(/@#{key}@/, value)
            end
        end
    end

    File.open(output_file, 'w') do |f|
        f.puts(lines)
    end
    puts "All good! Output file: #{output_file}"

end
    
# Get command line options
ARGV << "-h" if ARGV.size != 6
options = {}
OptionParser.new do |opts|
    opts.banner = "Usage: detokenize.rb [options]"
    opts.on("-i", "--inputfile [TOKENIZED-FILE]", "Input file to be detokenized") do |input_file|
        options[:input_file] = input_file
    end
    opts.on("-o", "--outputfile [DETOKENIZED-FILE]", "Detokenized Output file") do |output_file|
        options[:output_file] = output_file
    end
    opts.on("-a", "--attributesfile [ATTRIBUTES-FILE]", "File containing attribute key-value pairs") do |attributes_file|
        options[:attributes_file] = attributes_file
    end
    opts.on_tail("-h", "--help", "Show this message") do
        puts opts
        exit
    end
end.parse!

# Run detokenisation
detoken(options[:input_file],options[:output_file],options[:attributes_file])


