require 'rake'
require 'rake/gempackagetask'
load File.dirname(__FILE__) + '/css_writer.gemspec'

Rake::GemPackageTask.new(SPEC) do |pkg| 
  pkg.need_tar = true 
end 

task :test do
  ruby 'test/test_css_writer.rb'
end

task :default => [:test]
