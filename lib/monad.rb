require "monad/version"

module Monad
  class Monad
    def bind(func)
      raise "not implemented"
    end

    def self.unit(val)
      raise "not implemented"
    end

    def bindb(&block)
      bind(block)
    end
  end
end

require 'monad/failable'
