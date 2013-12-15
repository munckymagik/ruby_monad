require 'monad'

shared_examples "not implemented" do |obj, described_method, args|
  it "raises a not implemented exception when called" do
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


