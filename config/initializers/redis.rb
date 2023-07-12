# IMPORTANT: This is only set up to work for a development environment.
require 'redis'

$redis = Redis.new(host: 'localhost')