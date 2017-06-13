require 'bundler'
Bundler.require

run Opal::Server.new {|s|
  s.append_path 'app'
  s.main = 'application'

  # This can be used to provide a custom index file.
  # s.index_path = 'my_index.erb'
}
