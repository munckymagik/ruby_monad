require 'monad'

describe Monad do
end

describe Monad::Failable do
  describe '#initialize' do
    it 'takes an arbitrary value as a first parameter' do
      instance = described_class.new 1, false
      expect(instance.value).to be(1)
    end

    context 'when true is passed as the second parameter' do
      it 'represents success' do
        success = described_class.new 0, true
        expect(success.success?).to be_true
      end
    end

    context 'when false is passed as the second parameter' do
      it 'represents failure' do
        failure = described_class.new 1, false
        expect(failure.success?).to be_false
      end
    end
  end

  describe '#self.success' do
    it 'constructs a Failable representing success' do
      # when
      result = Monad::Failable.success(1234)

      # then
      expect(result.success?).to be_true
      expect(result.value).to eq(1234)
    end
  end

  describe '#self.failure' do
    it 'constructs a Failable representing failure' do
      # when
      result = Monad::Failable.failure(1234)

      # then
      expect(result.success?).to be_false
      expect(result.value).to eq(1234)
    end
  end

  describe '#bind' do
    context 'when the instance is a success' do
      it 'calls the bindee' do
        # given
        was_called = false
        bindee = lambda { |unused| was_called = true }
        success = described_class.new 0, true

        # when
        result = success.bind(bindee)

        # then
        expect(was_called).to be_true
      end

      it 'passes the value' do
        # given
        bindee = lambda { |val| val }
        success = described_class.new 9797, true

        # when
        result = success.bind(bindee)

        # then
        expect(result).to eq(9797)
      end
    end

    context 'when the instance is a failure' do
      it 'returns self' do
        # given
        bindee = lambda { |val| val }
        failure = described_class.new 9696, false

        # when
        result = failure.bind(bindee)

        # then
        expect(result).to equal(failure) # reference comparison
      end
    end
  end

  describe '#self.unit' do
    it 'always returns a Failable representing success' do
      # given

      # when
      result = Monad::Failable.unit(123)

      # then
      expect(result.success?).to be_true
      expect(result.value).to eq(123)
    end
  end

  describe '#to_s' do
    context 'when the instance is a success' do
      it 'returns a string indicating success' do
        # given
        success = described_class.new 123, true

        # when
        result = success.to_s

        # then
        expect(result).to eq("Success(123)")
      end
    end
    context 'when the instance is a failure' do
      it 'returns a string indicating failure' do
        # given
        success = described_class.new 123, false

        # when
        result = success.to_s

        # then
        expect(result).to eq("Failure(123)")
      end
    end
  end

  example 'handling divide by zero gracefully' do
    # given
    def fdiv(a, b)
      if b == 0
        Monad::Failable.failure("divide by zero")
      else
        Monad::Failable.success(a / b)
      end
    end

    def fdiv_with_binding(first_divisor)
      fdiv(2.0, first_divisor).bindb do |val1|
        fdiv(3.0, 1.0).bindb do |val2|
          fdiv(val1, val2).bindb do |val3|
            Monad::Failable.success(val3)
          end
        end
      end
    end

    # when
    result = fdiv_with_binding(1.0)

    # then
    expect(result.success?).to be_true
    expect(result.value).to eq(2.0 / 3.0)

    # when
    result = fdiv_with_binding(0.0)

    # then
    expect(result.success?).to be_false
    expect(result.value).to eq("divide by zero")
  end
end
