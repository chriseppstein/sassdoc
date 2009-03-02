module SassDoc
  class FileDocumentation < Documentation

    def initialize(node, comments = [])
     @node = node
     @comments = comments 
    end

    def name
      "FileName"
    end

    def signature
      name
    end

    def raw_documentation
      raw_file_documentation = []
      @comments.each {|comment|
        raw_file_documentation += super(comment)
      }
      raw_file_documentation
    end

    def to_plain_text
      sig = signature
      separator = "-" * (sig.length + 6)
      lines = ["File: #{sig}"]
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
