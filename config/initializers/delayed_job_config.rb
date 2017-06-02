Delayed::Worker.max_attempts = 5

# Optional but recommended for less future surprises.
# Fail at startup if method does not exist instead of later in a background job 
[[ExceptionNotifier::Notifier, :background_exception_notification]].each do |object, method_name|
  raise NoMethodError, "undefined method `#{method_name}' for #{object.inspect}" unless object.respond_to?(method_name, true)
end
