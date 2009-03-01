module SassDoc
  class MixinDocumentation < Documentation

      def name
        node.name
      end

      def arguments
        node.args
      end

      def parse_documentation!
        @general_doc = ""
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
            @general_doc << "\n" if @general_doc.length > 0
            @general_doc << line
          end
        end
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
        if (doc = general_doc).length > 0
          lines += [
            separator,
            general_doc,
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
end
