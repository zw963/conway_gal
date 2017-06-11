# 这里 require opal, 是 Ruby 版本的 opal.
# 目的是为了使用 Opal 的一些类方法, 用来增加 opal 的 LOAD_PATH, 以及 build 完整的 js.
require 'opal'

desc 'Build our app to js'
task :build do
  Opal.append_path 'app'
  File.unlink('app/grid.js') if File.exist? 'app/grid.js'
  File.binwrite 'app/grid.js', Opal::Builder.build('grid').to_s
end
