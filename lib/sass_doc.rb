require File.join(File.dirname(__FILE__), "sass_doc", "mixins")
require File.join(File.dirname(__FILE__), "sass_extensions")

module SassDoc
  class SassDocParser

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
