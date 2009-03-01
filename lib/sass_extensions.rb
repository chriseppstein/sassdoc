begin
  require 'sass'
rescue LoadError
  require 'rubygems'
  require 'sass'
end

module Sass
  module Tree
    class MixinDefNode < Node
      attr_accessor :name, :args
    end
    class VariableNode < Node
      attr_accessor :name
    end
    class CommentNode < Node

      def parse_documentation!(directives = [])
        @general_doc = []
        @arg_docs = {}
        current_directive = nil
        directive_name = nil
        raw_documentation.each do |line|
          if line =~ /^@([^\s]+) +([^\s]+)/ && directives.include?($1)
            current_directive = $1
            directive_name = $2
          elsif current_directive && line =~ /^  /
            @arg_docs[current_directive] ||= {}
            @arg_docs[current_directive][directive_name] << "\n" if  @arg_docs[current_directive][directive_name]

            (@arg_docs[current_directive][directive_name] ||= "") << line[2..-1]
          else
            current_directive = nil
            directive_name = nil
            @general_doc << line
          end
        end
      end

      def general_doc
        @general_doc
      end

      def arg_docs
        @arg_docs
      end

private

      def raw_documentation
        @raw_documentation ||= begin
          unless self.value =~ /^\*\*+/
            []
          else
            raw_lines(self, :first => true, :indent => -1)
          end
        end
      end

      def raw_lines(node, options = {})
        indent = options[:indent]||0
        lines = []
        line = "  "*[indent,0].max
        line << if node.respond_to?(:value)
          node.value
        elsif node.respond_to?(:text)
          node.text
        else
          ""
        end
        line = line.sub(/^\*\*+ */,'').strip if options[:first]
        lines << line unless line.length == 0
        node.children.each do |child|
          lines += raw_lines(child, :indent => indent + 1)
        end
        lines
      end

    end
  end
end
