RSpec::Matchers.define :validate_with do |validator|
  match do |subject|    
    subject.class.validators.map(&:class).include? validator
  end

  description do
    "validate with class #{validator}"
  end

  failure_message do |text|
    "expected to validate with #{validator}"
  end

  failure_message_when_negated do |text|
    "do not expected to validate with #{validator}"
  end
end
