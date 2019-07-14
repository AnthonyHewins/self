RSpec::Matchers.define :error_on do |template|
  match do |response|
    response.status == 422 && expect(response).to(render_template(template))
  end

  description do
    "return 422 Unprocessable entity and render #{template}"
  end

  failure_message do |actual|
    "expect response to return 422 Unprocessable entity and render #{template}"
  end

  failure_message_when_negated do |text|
    "expect response to not return 422 Unprocessable entity and render #{template}"
  end
end
