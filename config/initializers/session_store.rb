# Be sure to restart your server when you modify this file.

#AmiRoutine::Application.config.session_store :cookie_store, key: '_ami_routine_session'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
AmiRoutine::Application.config.session_store :active_record_store
