require 'opal'
require 'opal-jquery'

desc 'Build our app to conway.js'
task :build do
  File.open('conway.js', 'w+') do |out|
    out << Opal.compile(File.read('app/conway.rb'))
  end

  # 只需要运行一次.
  # File.open("app/opal.js", "w+") do |out|
  #   out << Opal::Builder.build('opal')
  # end
end
