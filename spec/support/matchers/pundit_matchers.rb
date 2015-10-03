RSpec::Matchers.define :permit_action do |action|
  match do |policy|
    policy.public_send("#{action}?")
  end

  failure_message do |policy|
    "#{policy.class} does not permit #{action} on #{policy.record} for " +
      "#{policy.user.inspect}."
  end

  failure_message_when_negated do |policy|
    "#{policy.class} does not forbid #{action} on #{policy.record} for " +
      "#{policy.user.inspect}."
  end
end

RSpec::Matchers.define :permit_new_and_create do
  match do |policy|
    policy.new? and policy.create?
  end

  failure_message do |policy|
    "#{policy.class} does not permit the new or create action on " +
      "#{policy.record} for #{policy.user.inspect}."
  end

  failure_message_when_negated do |policy|
    "#{policy.class} does not forbid the new or create action on " +
      "#{policy.record} for #{policy.user.inspect}."
  end
end

RSpec::Matchers.define :permit_edit_and_update do
  match do |policy|
    policy.edit? and policy.update?
  end

  failure_message do |policy|
    "#{policy.class} does not permit the edit or update action on " +
      "#{policy.record} for #{policy.user.inspect}."
  end

  failure_message_when_negated do |policy|
    "#{policy.class} does not forbid the edit or update action on " +
      "#{policy.record} for #{policy.user.inspect}."
  end
end

RSpec::Matchers.define :forbid_action do |action|
  match do |policy|
    !policy.public_send("#{action}?")
  end

  failure_message do |policy|
    "#{policy.class} does not forbid #{action} on #{policy.record} for " +
      "#{policy.user.inspect}."
  end

  failure_message_when_negated do |policy|
    "#{policy.class} does not permit #{action} on #{policy.record} for " +
      "#{policy.user.inspect}."
  end
end

RSpec::Matchers.define :forbid_new_and_create do
  match do |policy|
    !policy.new? and !policy.create?
  end

  failure_message do |policy|
    "#{policy.class} does not forbid the new or create action on " +
      "#{policy.record} for #{policy.user.inspect}."
  end

  failure_message_when_negated do |policy|
    "#{policy.class} does not permit the new or create action on " +
      "#{policy.record} for #{policy.user.inspect}."
  end
end

RSpec::Matchers.define :forbid_edit_and_update do
  match do |policy|
    !policy.edit? and !policy.update?
  end

  failure_message do |policy|
    "#{policy.class} does not forbid the edit or update action on " +
      "#{policy.record} for #{policy.user.inspect}."
  end

  failure_message_when_negated do |policy|
    "#{policy.class} does not permit the edit or update action on " +
      "#{policy.record} for #{policy.user.inspect}."
  end
end
