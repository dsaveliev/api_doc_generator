RSpec::Matchers.define :match_response_schema do |schema|
  match do |response|
    path = Rails.root.join("schemas", schema + ".json")
    @errors = JSON::Validator.fully_validate(path.to_s, response.body)
    @errors.blank?
  end

  failure_message do
    @errors.join("\n") if @errors.present?
  end

  description do
    "be valid schema of #{schema}"
  end
end
