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

  class Failable < Monad
    attr_reader :value, :is_success
    alias :success? :is_success

    def initialize(value, is_success)
      @value = value
      @is_success = is_success
    end

    def bind(bindee)
      if @is_success
        bindee.call(@value)
      else
        self
      end
    end

    def self.unit(val)
      self.new(val, true)
    end

    def to_s
      if @is_success
        "Success(#{@value})"
      else
        "Failure(#{@value})"
      end
    end
  end

  def self.success(value)
    Failable.new value, true
  end

  def self.failure(value)
    Failable.new value, false
  end
end
