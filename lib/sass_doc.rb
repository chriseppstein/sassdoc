require File.join(File.dirname(__FILE__), "sass_extensions")

require File.join(File.dirname(__FILE__), "sass_doc", "documentation")
require File.join(File.dirname(__FILE__), "sass_doc", "mixin_documentation")
require File.join(File.dirname(__FILE__), "sass_doc", "file_documentation")
require File.join(File.dirname(__FILE__), "sass_doc", "variable_documentation")

module SassDoc
  class SassDocParser

    attr_accessor :mixins, :filename

    def initialize(filename, options = {})
      @filename = filename
      @options = options.dup
      @contents = File.open(filename) do |f|
        f.read
      end
      @file_documentation = nil
      @mixins = []
      @variables = []
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
      file_comments = []
      prev_child = nil
      @ast.children.each do |child|
        if child.is_a?(Sass::Tree::CommentNode) and child.value =~ /^\*\*+\\\\/
          comment = child
          file_comments << comment
        elsif child.is_a? Sass::Tree::VariableNode
          comment = if prev_child.is_a?(Sass::Tree::CommentNode)
            prev_child
          end
          @variables << VariableDocumentation.new(child, comment)
        elsif child.is_a? Sass::Tree::MixinDefNode
          comment = if prev_child.is_a?(Sass::Tree::CommentNode)
            prev_child
          end
          @mixins << MixinDocumentation.new(child, comment)
        end
        prev_child = child
      end
      @file_documentation = FileDocumentation.new(nil, file_comments)
      self
    end

    def to_plain_text
      output = @file_documentation.to_plain_text
      output += "\n\n" + @mixins.map{|mixin| mixin.to_plain_text}.join("\n\n")
      output += "\n\n" + @variables.map{|variable| variable.to_plain_text}.join("\n\n")
    end
  end
end
