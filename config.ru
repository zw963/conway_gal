require 'bundler'
Bundler.require

require 'opal/sprockets/server'

run Opal::Sprockets::Server.new {|s|
  s.append_path 'app'
  s.append_path 'js'
  s.main = 'application'

  # This can be used to provide a custom index file.
  s.index_path = 'index.html.erb'
}
