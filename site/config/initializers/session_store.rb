# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_restfulie-site_session',
  :secret      => '3b3bd5c29c58be787d4fb2590c25768a0a6526f58b39ae3cca8d87ee20addf148f3cfa0911f6d9935edff55c7e9e5256ba701a5a13d20835105c157cb9160cf5'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
