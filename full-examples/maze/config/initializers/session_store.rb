# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_mazes_session',
  :secret      => 'e3ef09d5f6f00b5d3bd170ff4dd25c5dd2c728fc06515f1e5c5383fefb0e07e095b51db65cd8f36f345d9777ad375394c3577ed7b82da2fd91845d9a2a232ae3'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
