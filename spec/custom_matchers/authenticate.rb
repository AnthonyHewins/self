RSpec::Matchers.define :authenticate do |&block|
  match do |subject|
    begin
      block.call
      false
    rescue Concerns::Permission::AccessDenied
      true
    end
  end

  description do
    "RSpec matcher for checking if a route forces authentication"
  end

  failure_message do |text|
    "expected this route to authenticate"
  end

  failure_message_when_negated do |text|
    "expected this route to not authenticate"
  end
end
