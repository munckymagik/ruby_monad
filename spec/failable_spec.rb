require 'monad'

include Monad

describe Failable do
  it "is abstract" do
    # given
    failable = Failable.new 123

    # then
    expect {
      # when
      failable.bindb { |val| val }
    }.to raise_error("not implemented")
  end

  describe '#initialize' do
    it 'takes an arbitrary value as a first parameter' do
      instance = described_class.new 1
      expect(instance.value).to be(1)
    end
  end

  describe '#self.success' do
    it 'constructs a Failable representing success' do
      # when
      result = Failable.success(1234)

      # then
      expect(result.success?).to be_true
      expect(result.value).to eq(1234)
    end
  end

  describe '#self.failure' do
    it 'constructs a Failable representing failure' do
      # when
      result = Failable.failure(1234)

      # then
      expect(result.success?).to be_false
      expect(result.value).to eq(1234)
    end
  end

  describe '#self.unit' do
    it 'always returns a Failable representing success' do
      # when
      result = Failable.unit(123)

      # then
      expect(result.success?).to be_true
      expect(result.value).to eq(123)
    end
  end

  def fdiv(a, b)
    if b == 0
      Failable.failure("divide by zero")
    else
      Failable.success(a / b)
    end
  end

  def fdiv_with_binding(first_divisor)
    fdiv(2.0, first_divisor).bindb do |val1|
      fdiv(3.0, 1.0).bindb do |val2|
        fdiv(val1, val2).bindb do |val3|
          Failable.success(val3)
        end
      end
    end
  end

  example 'fdiv returns the quotient of dividing one floating point number by another' do
    # when
    result = fdiv_with_binding(1.0)

    # then
    expect(result.success?).to be_true
    expect(result.value).to eq(2.0 / 3.0)
  end

  example 'fdiv handles divide by zero gracefully by using Failable' do
    # when
    result = fdiv_with_binding(0.0)

    # then
    expect(result.success?).to be_false
    expect(result.value).to eq("divide by zero")
  end
end

describe Success do
  it "represents success" do
    expect(Success.new(0).success?).to be_true
  end

  describe '#bind' do
    it 'calls the bindee' do
      # given
      was_called = false
      bindee = lambda { |unused| was_called = true }
      success = described_class.new 0

      # when
      result = success.bind(bindee)

      # then
      expect(was_called).to be_true
    end

    it 'passes the value' do
      # given
      bindee = lambda { |val| val }
      success = described_class.new 9797

      # when
      result = success.bind(bindee)

      # then
      expect(result).to eq(9797)
    end
  end

  describe '#to_s' do
    it 'returns a string indicating success' do
      # given
      success = described_class.new 123

      # when
      result = success.to_s

      # then
      expect(result).to eq("Success(123)")
    end
  end
end

describe Failure do
  it "represents failure" do
    expect(Failure.new(0).success?).to be_false
  end

  describe '#bind' do
    it 'returns self' do
      # given
      bindee = lambda { |val| val }
      failure = described_class.new 9696

      # when
      result = failure.bind(bindee)

      # then
      expect(result).to equal(failure) # reference comparison
    end
  end

  describe '#to_s' do
    it 'returns a string indicating failure' do
      # given
      success = described_class.new 123

      # when
      result = success.to_s

      # then
      expect(result).to eq("Failure(123)")
    end
  end
end
