module Monad
  class Failable < Monad
    attr_reader :value

    def initialize(value)
      @value = value
    end

    def self.success(value)
      Success.new value
    end

    def self.failure(value)
      Failure.new value
    end

    def self.unit(val)
      self.success(val)
    end
  end

  class Success < Failable
    def success?
      true
    end

    def bind(bindee)
      bindee.call(@value)
    end

    def to_s
      "Success(#{@value})"
    end
  end

  class Failure < Failable
    def success?
      false
    end

    def bind(bindee)
      self
    end

    def to_s
      "Failure(#{@value})"
    end
  end
end
