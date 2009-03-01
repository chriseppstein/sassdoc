module SassDoc
  class VariableDocumentation < Struct.new(:node, :comment)

    def name
      node.name
    end

    def variable_doc
      comment.parse_documentation! unless comment.general_doc
      comment.general_doc
    end

    def signature
      "!#{name}"
    end

    def to_plain_text
      sig = signature
      separator = "-" * (sig.length + 11)
      lines = ["Variable: #{sig}"]
      if (doc = variable_doc).length > 0
        lines += [
          separator,
          variable_doc,
          ""
        ]
      end
      lines.join("\n")
    end
  end
end
