require 'sprockets'
require 'tilt'
require 'coffee-react'
require 'coffee_script'

module Sprockets
  # Preprocessor that runs CJSX source files through coffee-react-transform
  # then compiles with coffee-script
  class CoffeeReactScript < Tilt::Template
    CJSX_EXTENSION = %r{\.cjsx[^/]*?$}.freeze
    CJSX_PRAGMA = /^\s*#[ \t]*@cjsx/i.freeze

    def prepare; end

    def evaluate(scope, _locals)
      if scope.pathname.to_s =~ /\.coffee\.cjsx/
        ::CoffeeReact.transform(data)
      elsif scope.pathname.to_s =~ CJSX_EXTENSION || data =~ CJSX_PRAGMA
        ::CoffeeScript.compile(::CoffeeReact.transform(data))
      else
        data
      end
    end

    def self.call(input)
      filename = (input[:source_path] || input[:filename]).to_s
      data = input[:data]
      if filename =~ /\.coffee(\.source-.*)?\.cjsx/
        ::CoffeeReact.transform(data)
      elsif filename =~ CJSX_EXTENSION
        ::CoffeeScript.compile(::CoffeeReact.transform(data))
      else
        data
      end
    end
  end
end
