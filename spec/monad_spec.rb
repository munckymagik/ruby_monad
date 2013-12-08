require 'monad'

shared_examples "not implemented" do |obj, described_method, args|
  it "raises a not implemented exepection when called" do
    expect {
      obj.send(described_method, *args)
    }.to raise_error("not implemented")
  end
end

describe Monad::Monad do
  describe '#bind' do
    include_examples "not implemented", described_class.new, :bind, 0
  end

  describe '#unit' do
    include_examples "not implemented", described_class, :unit, 0
  end

  describe '#bindb' do
    it 'calls bind' do
      # given
      bind_was_called = false

      class MonadThing < Monad::Monad
        def bind(func)
          func.call
        end
      end

      thing = MonadThing.new

      # when
      thing.bindb do
        bind_was_called = true
      end

      # then
      expect(bind_was_called).to be_true
    end
  end
end

describe Monad do
  describe '#success' do
    it 'constructs a Failable representing success' do
      # when
      result = Monad.success(1234)

      # then
      expect(result.success?).to be_true
      expect(result.value).to eq(1234)
    end
  end

  describe '#failure' do
    it 'constructs a Failable representing failure' do
      # when
      result = Monad.failure(1234)

      # then
      expect(result.success?).to be_false
      expect(result.value).to eq(1234)
    end
  end
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
end
