# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_JuridicoWebAdmin_session',
  :secret      => '98f1d24aff476e112c6f868fb45f99dbbf35c39d5419f67e4fa667b0dbce3cb069fa7e831503d15299e8cb480205642a4a085b4797077a6a67c5e072854d8cc8'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
