require 'optparse'
require File.join(File.dirname(__FILE__), "sass_doc")

module SassDoc
  class Exec
    def initialize(arguments)
      @arguments = arguments
      @options = {}
      process_arguments!
    end
    def process_arguments!
       option_parser = OptionParser.new do |opts|
         opts.on("--compass") do
           begin
             require 'compass'
           rescue LoadError
             require 'rubygems'
             require 'compass'
           end
           @options[:compass] = true
         end
       end
       option_parser.parse!(@arguments)    
    end
    def run!
      @arguments.each do |file|
        if @arguments.size > 1
          puts "File: #{file}"
        end
        parser = SassDoc::SassDocParser.new(file, @options)
        puts parser.parse!.to_plain_text
      end
    end
  end
end
