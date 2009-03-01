module SassDoc
  class MixinDocumentation < Struct.new(:node, :comment)

    def name
      node.name
    end

    def arguments
      node.args
    end

    def mixin_doc
      comment.parse_documentation!(['parameter']) unless comment.general_doc
      comment.general_doc
    end

    def arg_docs
      comment.parse_documentation!(['parameter']) unless comment.arg_docs
      comment.arg_docs
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
        if arg_docs['parameter'][arg[:name]]
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
