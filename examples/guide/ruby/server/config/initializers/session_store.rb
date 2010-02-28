# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_hotel-system_session',
  :secret      => '2a3b95b892fbf96fd63e737e31877927a4e326c94199848c297871ce347eacff2294b66065c0a5076aaa6391d4d52656c1bc4b6584860f7dab8a68facf9055d4'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
