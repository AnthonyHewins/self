RSpec::Matchers.define :have_alias_method do |new_alias, old_method|
  match do |obj|
    obj.send(new_alias) == obj.send(old_method)
  end

  description do
    "has alias method ##{new_alias} that's the same for ##{old_method}"
  end
  
  failure_message do |_|
    "expected ##{new_alias} to return the same value as ##{old_method}"
  end
end
