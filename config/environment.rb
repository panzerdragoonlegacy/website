# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

# Globally set JSON key format to lower camelcase.
Jbuilder.key_format camelize: :lower
Jbuilder.deep_format_keys true
