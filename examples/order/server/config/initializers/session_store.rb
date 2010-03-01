# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_server_session',
  :secret      => '8cfcc6a3f61cc58d3935330e7be9c4a75f430d4170f29e844987226053d6fcc5ac03836a29fcabf7f37a7def07407a7ade9169d0ce8edb98dda234878e8ab2de'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
