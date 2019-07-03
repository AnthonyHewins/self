RSpec::Matchers.define :validate_with do |validator|
  match do |subject|    
    subject.class.validators.map(&:class).include? validator
  end

  description do
    "RSpec matcher for validates_with"
  end

  failure_message do |text|
    "expected to validate with #{validator}"
  end

  failure_message_when_negated do |text|
    "do not expected to validate with #{validator}"
  end
end
