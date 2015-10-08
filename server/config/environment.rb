# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Ping::Application.initialize!

require "pingpp"
Pingpp.api_key = "sk_test_C8SCK4z5ennHvLKazD8SaznH"