# Be sure to restart your server when you modify this file.

TheWillOfTheAncients::Application.config.session_store :cookie_store, :key => APP_CONFIG['session']['key']

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# TheWillOfTheAncients::Application.config.session_store :active_record_store
