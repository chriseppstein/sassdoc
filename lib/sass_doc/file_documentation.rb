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

protected

    def raw_documentation
      @raw_documentation ||= begin
        raw_documentation = []
        @comments.each {|comment|
          unless comment && comment.value =~ /^\*\*+\\\\/
            []
          else
            raw_documentation += raw_lines(comment, :first => true, :indent => -1)
          end
        }
        raw_documentation
      end
    end

  end
end
