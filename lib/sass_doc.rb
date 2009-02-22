require File.join(File.dirname(__FILE__), "sass_extensions")

module SassDoc
  class MixinParser

    class Mixin < Struct.new(:node, :comment)

      def name
        node.name
      end

      def arguments
        node.args
      end

      def raw_documentation
        @raw_documentation ||= begin
          unless comment && comment.value =~ /^\*\*+/
            []
          else
            raw_lines(comment, :first => true, :indent => -1)
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

      def parse_documentation!
        @mixin_doc = ""
        @arg_docs = {}
        current_parameter = nil
        raw_documentation.each do |line|
          if line =~ /^@parameter +([^\s]+)/
            current_parameter = $1
          elsif current_parameter && line =~ /^  /
            (@arg_docs[current_parameter] ||= "") << "\n" if @arg_docs[current_parameter]
            (@arg_docs[current_parameter] ||= "") << line[2..-1]
          else
            current_parameter = nil
            @mixin_doc << "\n" if @mixin_doc.length > 0
            @mixin_doc << line
          end
        end
      end

      def mixin_doc
        parse_documentation! unless @mixin_doc
        @mixin_doc
      end

      def arg_docs
        parse_documentation! unless @arg_docs
        @arg_docs
      end

      def signature
        text = "+#{name}"
        if arguments.any?
          text << "("
          optional_found = false
          arguments.each_with_index do |arg, i|
            if arg[:default_value] && !optional_found
              text << "["
              optional_found = true
            end
            text << ", " unless i == 0
            text << arg[:name]
          end
          text << "]" if optional_found
          text << ")"
        end
        text
      end

      def to_plain_text
        sig = signature
        separator = "-" * (sig.length + 7)
        lines = ["Mixin: #{sig}"]
        if (doc = mixin_doc).length > 0
          lines += [
            separator,
            mixin_doc,
            ""
          ]
        end
        arguments.each do |arg|
          if arg[:default_value] || arg_docs[arg[:name]]
            firstline = "Parameter: #{arg[:name]}"
            firstline << " (default value: #{arg[:default_value]})" if arg[:default_value]
            lines << firstline
            if (doc = arg_docs[arg[:name]])
              doc.split(/\n/).each do |line|
                lines << "  #{line}"
              end
            end
          end
        end
        lines.join("\n")
      end
    end

    attr_accessor :mixins, :filename

    def initialize(filename, options = {})
      @filename = filename
      @options = options.dup
      @contents = File.open(filename) do |f|
        f.read
      end
      @mixins = []
    end

    def parse!
      engine_options = if @options.delete(:compass)
        Compass.sass_engine_options
      else
        {}
      end
      engine_options.merge(@options)
      (engine_options[:load_paths] ||= []) << File.dirname(filename)
      @ast = Sass::Engine.new(@contents, engine_options).send :render_to_tree
      prev_child = nil
      @ast.children.each do |child|
        if child.is_a? Sass::Tree::MixinDefNode
          comment = if prev_child.is_a?(Sass::Tree::CommentNode)
            prev_child
          end
          @mixins << Mixin.new(child, comment)
        end
        prev_child = child
      end
      self
    end

    def to_plain_text
      @mixins.map{|mixin| mixin.to_plain_text}.join("\n\n")
    end
  end
end