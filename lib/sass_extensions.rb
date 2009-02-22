begin
  require 'sass'
rescue LoadError
  require 'rubygems'
  require 'sass'
end

module Sass
  module Tree
    class MixinDefNode < Node
      attr_accessor :name, :args
    end
  end
end
