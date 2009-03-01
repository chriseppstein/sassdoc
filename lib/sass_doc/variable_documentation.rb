module SassDoc
  class VariableDocumentation < Documentation

    def name
      node.name
    end

    def signature
      "!#{name}"
    end

    def to_plain_text
      sig = signature
      separator = "-" * (sig.length + 11)
      lines = ["Variable: #{sig}"]
      if (doc = general_doc).length > 0
        lines += [
          separator,
          general_doc,
          ""
        ]
      end
      lines.join("\n")
    end
  end
end
