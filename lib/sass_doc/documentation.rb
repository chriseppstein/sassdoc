module SassDoc
  class Documentation < Struct.new(:node, :comment)

    def parse_documentation!
      @general_doc = ""
      raw_documentation.each do |line|
        @general_doc << "\n" if @general_doc.length > 0
        @general_doc << line
      end
    end

    def general_doc
      parse_documentation! unless @general_doc
      @general_doc
    end

private 

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
      line = " "*[indent,0].max
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
