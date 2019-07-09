RSpec::Matchers.define :define_constant do |sym, val|
  match do |subject|
    expect(subject.class.const_get sym).to eq val
  end

  description do
    "RSpec matcher for checking a constant's value"
  end

  failure_message do |text|
    "expected #{sym} to have value #{val}"
  end

  failure_message_when_negated do |text|
    "expected #{sym} to not have value #{val}"
  end
end
